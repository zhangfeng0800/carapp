using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data;
using System.Data.SqlClient;
using BLL;
using Com;
using System.Text;
using Model;
using Common;
using System.Web.Security;
using DBUtility;
using Com.UnionPay.Upmp;
namespace WebApp.twicepay
{
    public partial class HandleTwicePay : System.Web.UI.Page
    {
        public string paydata = "";
        public string orderId = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分


                if (Request.QueryString["orderId"] != null)
                {
                    string Id = Request.QueryString["orderId"].ToString();
                    orderId = Id;
                    DataTable dt = new OrderBLL().GetOrderById(Id);
                    if (dt.Rows.Count == 0)
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    string orderdate = Convert.ToDateTime(dt.Rows[0]["orderdate"].ToString()).ToString("yyyyMMddHHmmss");
                    if (orderdate != orderId.Substring(0, orderId.Length - 5))
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    DataTable mem = new OrderBLL().GetMemByOrderId(Id);
                    UserAccount objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    if (Convert.ToInt32(dt.Rows[0]["orderStatusID"]) == 6 && Convert.ToInt32(dt.Rows[0]["paystatus"]) == 1)
                    {
                        Response.Redirect("/twicepay/TwicePaySuccess.aspx?orderId=" + Id);
                    }
                    else
                    {
                        payStatus.InnerText = "未付款";
                        totalFee.InnerText = Math.Round(float.Parse(dt.Rows[0]["totalMoney"].ToString()), 2) + "元";
                        unpaidMo.InnerText = Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2) + "元"; ;
                        member.InnerText = mem.Rows[0]["compname"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                        passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                        blance.InnerText = objUser.Balance.ToString() + "元";
                    }
                }
                if (Request.Form["handlePay"] != null && Request.Form["orderID"] != null && Request.Form["paystyle"] != null && Request.Form["IsUse"] != null && Request.Form["userPassword"] != null)
                {
                    string orderId = Request.Params["orderId"].ToString();
                    DataTable dt = new OrderBLL().GetOrderById(orderId);
                    if (dt.Rows.Count == 0)
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    string orderdate = Convert.ToDateTime(dt.Rows[0]["orderdate"].ToString()).ToString("yyyyMMddHHmmss");
                    if (orderdate != orderId.Substring(0, orderId.Length - 5))
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    if (Convert.ToInt32(dt.Rows[0]["orderStatusID"]) == 6 && Convert.ToInt32(dt.Rows[0]["paystatus"]) == 1)//防止用户返回误操作再付款
                    {
                        Response.Redirect("/twicepay/TwicePaySuccess.aspx?orderId=" + orderId);
                    }
                    DataTable userAccount = new UserAccountBLL().GetDataTable(Convert.ToInt32(dt.Rows[0]["userID"]));//个人账户与集团下属个人账户信息
                    UserAccount objUser;
                    Account objAccount = new Account();
                    objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    if (Request.Params["IsUse"].ToString() == "use")//使用账户余额
                    {
                        string userPwd = Request.Params["userPassword"].ToString();
                        if (userAccount.Rows[0]["payPassword"].ToString() == Common.EncryptAndDecrypt.Encrypt(userPwd))//个人账户密码或是集团下属账户密码
                        {
                            if (objUser.Balance >= decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()))//账户余额完全支付
                            {
                                int i = new UserAccountBLL().UpdateAccount(objUser.Id, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()), "reduce");
                                if (i != 0)
                                {
                                    CarInfo car = new BLL.CarInfoBLL().GetModel(dt.Rows[0]["carId"].ToString());
                                    objAccount.Action = Common.Action.PAYORDER;
                                    objAccount.userID = Convert.ToInt32(dt.Rows[0]["userID"]);
                                    objAccount.Type = Common.PayType.Pay;
                                    objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                                    objAccount.Balance = objUser.Balance - decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                                    objAccount.Money = decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                                    objAccount.OrderId = dt.Rows[0]["orderId"].ToString();
                                    new AccountBLL().InsertAccount(objAccount);

                                    int m = new OrderBLL().UpdateOrderInfo(6, orderId, DateTime.Now.ToLocalTime());
                                    if (m == 0)
                                    {
                                        Response.Write("支付失败！");
                                        Response.End();
                                    }


                                    Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), userAccount.Rows[0]["telphone"].ToString());//给下单人发短信
                                    Common.SMS.driver_OrderComplete(car.telPhone.ToString(), dt.Rows[0]["orderId"].ToString(), car.telPhone);//给司机发短信
                                    if (dt.Rows[0]["SMSReceiver"].ToString() == "1" && userAccount.Rows[0]["telphone"].ToString() != dt.Rows[0]["passengerPhone"].ToString())
                                    {
                                        Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), dt.Rows[0]["passengerPhone"].ToString());//给乘车人发的
                                    }
                                    new BLL.DirverAccountBLL().PustMessageToDriver(car.Id, orderId + "号订单已成功完成。");
                                    new RestrictBLL().addRestrict(Convert.ToInt32(dt.Rows[0]["userID"]), decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                    new BLL.UserAccountBLL().AddScore(Common.DataTableToList.List<Model.Orders>(dt).FirstOrDefault());
                                    Response.Redirect("/twicepay/TwicePaySuccess.aspx?orderId=" + orderId);
                                }
                                else
                                {
                                    Response.Write("支付失败！");
                                    Response.End();
                                }
                            }
                            else//账户余额不足
                            {
                                string paystyle = Request.Params["paystyle"].ToString();
                                decimal money = decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()) - objUser.Balance;
                                switch (paystyle)
                                {
                                    case "alipay":
                                        {
                                            HandleAlipay(orderId, money);
                                            break;
                                        }
                                    case "creditpay":
                                        {
                                            HandleCreditpay(orderId, money);
                                            break;
                                        }
                                    case "debitpay":
                                        {
                                            HandleDreditpay(orderId, money);
                                            break;
                                        }
                                    case "bindcard":
                                        {
                                            string bindid = Request.Form["bindid"].ToString();
                                            HandleBindPay(orderId, money, bindid);
                                            break;
                                        }
                                    case "upmpay":
                                        {
                                            HandleUPMP(orderId, money);
                                            break;
                                        }
                                }
                            }
                        }
                        else//不正确（没啥必要）
                        {
                            Response.Write("密码不正确");
                            Response.End();
                        }
                    }
                    else//不使用账户余额
                    {
                        string paystyle = Request.Params["paystyle"].ToString();
                        switch (paystyle)
                        {
                            case "alipay":
                                {
                                    HandleAlipay(orderId, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                    break;
                                }
                            case "creditpay":
                                {
                                    HandleCreditpay(orderId, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                    break;
                                }
                            case "debitpay":
                                {
                                    HandleDreditpay(orderId, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                    break;
                                }
                            case "bindcard":
                                {
                                    string bindid = Request.Form["bindid"].ToString();
                                    HandleBindPay(orderId, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()), bindid);
                                    break;
                                }
                            case "upmpay":
                                {
                                    HandleUPMP(orderId, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                    break;
                                }
                        }
                    }
                }
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }
        #region 支付宝付款的处理函数
        public void HandleAlipay(string orderId, decimal money)
        {
            //DataTable dt = new OrderBLL().GetOrderById(orderId);
            Model.Orders order = new OrderBLL().GetModel(orderId);
            if (string.IsNullOrEmpty(order.YeePayID))
            {
                order.YeePayID = "1";
            }
            else
            {
                order.YeePayID = (int.Parse(order.YeePayID) + 1).ToString();
            }
            new OrderBLL().upDateAllByModule(order);
            DataTable rentCar = new RentCarBLL().GetCarDetail(order.rentCarID);
            string GATEWAY_NEW = "http://wappaygw.alipay.com/service/rest.htm?";
            string format = "xml";
            string v = "2.0";
            string req_id = DateTime.Now.ToString("yyyyMMddHHmmss");
            string notify_url = WebConfigurationManager.AppSettings["twiceAlipay"] + "/notify_url.aspx";
            string call_back_url = WebConfigurationManager.AppSettings["twiceAlipay"] + "/call_back_url.aspx";
            string merchant_url = WebConfigurationManager.AppSettings["twiceAlipay"] + "/Interrupt.aspx";
            string seller_email = "hbfangrun@126.com";
            string out_trade_no = orderId + "_" + order.YeePayID;
            string subject = "爱易租用车服务" + "——" + rentCar.Rows[0]["name"].ToString() + "（" + rentCar.Rows[0]["typeName"].ToString() + "）";
            string total_fee =money.ToString();
            //请求业务参数详细
            string req_dataToken = "<direct_trade_create_req><notify_url>" + notify_url + "</notify_url><call_back_url>" + call_back_url + "</call_back_url><seller_account_name>" + seller_email + "</seller_account_name><out_trade_no>" + out_trade_no + "</out_trade_no><subject>" + subject + "</subject><total_fee>" + total_fee + "</total_fee><merchant_url>" + merchant_url + "</merchant_url></direct_trade_create_req>";
            //把请求参数打包成数组
            Dictionary<string, string> sParaTempToken = new Dictionary<string, string>();
            sParaTempToken.Add("partner", Com.Config.Partner);
            sParaTempToken.Add("_input_charset", Com.Config.Input_charset.ToLower());
            sParaTempToken.Add("sec_id", Com.Config.Sign_type.ToUpper());
            sParaTempToken.Add("service", "alipay.wap.trade.create.direct");
            sParaTempToken.Add("format", format);
            sParaTempToken.Add("v", v);
            sParaTempToken.Add("req_id", req_id);
            sParaTempToken.Add("req_data", req_dataToken);
            //建立请求
            string sHtmlTextToken = Submit.BuildRequest(GATEWAY_NEW, sParaTempToken);
            //URLDECODE返回的信息
            Encoding code = Encoding.GetEncoding(Com.Config.Input_charset);
            sHtmlTextToken = HttpUtility.UrlDecode(sHtmlTextToken, code);
            //解析远程模拟提交后返回的信息
            Dictionary<string, string> dicHtmlTextToken = Submit.ParseResponse(sHtmlTextToken);
            //获取token
            string request_token = dicHtmlTextToken["request_token"];
            //下面该调用支付接口了！
            //业务详细
            string req_data = "<auth_and_execute_req><request_token>" + request_token + "</request_token></auth_and_execute_req>";
            //把请求参数打包成数组
            Dictionary<string, string> sParaTemp = new Dictionary<string, string>();
            sParaTemp.Add("partner", Com.Config.Partner);
            sParaTemp.Add("_input_charset", Com.Config.Input_charset.ToLower());
            sParaTemp.Add("sec_id", Com.Config.Sign_type.ToUpper());
            sParaTemp.Add("service", "alipay.wap.auth.authAndExecute");
            sParaTemp.Add("format", format);
            sParaTemp.Add("v", v);
            sParaTemp.Add("req_data", req_data);
            //建立请求
            string sHtmlText = Submit.BuildRequest(GATEWAY_NEW, sParaTemp, "get", "确认");
            Response.Write(sHtmlText);
        }
        #endregion
        #region 易宝信用卡付款的处理函数
        public void HandleCreditpay(string orderId, Decimal money)
        {
            string apiprefix = APIURLConfig.apiprefix;
            string creditpayURI = APIURLConfig.creditWebpayURI;
            string postParams = YeepayCommon(orderId, money);
            string url = apiprefix + creditpayURI + "?" + postParams;
            Response.Redirect(url);
        }
        #endregion
        #region 易宝储蓄卡付款的处理函数
        public void HandleDreditpay(string orderId, decimal money)
        {
            string apiprefix = APIURLConfig.apiprefix;
            string creditpayURI = APIURLConfig.debitWebpayURI;
            string postParams = YeepayCommon(orderId, money);
            string url = apiprefix + creditpayURI + "?" + postParams;
            Response.Redirect(url);
        }
        #endregion
        #region 易宝付款common部分
        public string YeepayCommon(string orderId, decimal money)
        {
            DataTable dt = new OrderBLL().GetOrderById(orderId);
            Model.Orders orders = new OrderBLL().GetModel(orderId);
            DataTable rentCar = new RentCarBLL().GetCarDetail(Convert.ToInt32(dt.Rows[0]["rentCarID"]));
            string merchantAccount = Config.merchantAccount;
            string merchantPublickey = Config.merchantPublickey;
            string merchantPrivatekey = Config.merchantPrivatekey;
            string yibaoPublickey = Config.yibaoPublickey;
            string merchantAesKey = AES.GenerateAESKey();
            int amount =Convert.ToInt32((money * 100));
            int currency = 156;
            string identityid = dt.Rows[0]["userID"].ToString();
            int identitytype = 0;
            string YeePayID2 = "";
            if (orders.YeePayID2 == "")
            {
                if (orders.YeePayID == "")
                {
                    YeePayID2 = "0";
                }
                else
                {
                    YeePayID2 = (Convert.ToInt32(dt.Rows[0]["YeePayID"]) + 1).ToString();
                }
            }
            else
            {
                YeePayID2 = (Convert.ToInt32(dt.Rows[0]["YeePayID2"]) + 1).ToString();
            }
            orders.YeePayID2 = YeePayID2;
            new OrderBLL().upDateAllByModule(orders);
            orderId = orderId + "x" + YeePayID2;
            string orderid = orderId;
            string other = dt.Rows[0]["passengerPhone"].ToString();
            string productcatalog = "1";
            string productdesc = "爱易租用车服务";
            string productname = "爱易租用车服务" + "——" + rentCar.Rows[0]["name"].ToString() + "（" + rentCar.Rows[0]["typeName"].ToString() + "）";
            DateTime t1 = DateTime.Now;
            DateTime t2 = new DateTime(1970, 1, 1);
            double t = t1.Subtract(t2).TotalSeconds;
            int transtime = (int)t;
            string userip = Request.UserHostAddress;
            string userua = Request.Browser.Type;
            SortedDictionary<string, object> sd = new SortedDictionary<string, object>();
            sd.Add("merchantaccount", merchantAccount);
            sd.Add("amount", amount);
            sd.Add("currency", currency);
            sd.Add("identityid", identityid);
            sd.Add("identitytype", identitytype);
            sd.Add("orderid", orderid);
            sd.Add("other", other);
            sd.Add("productcatalog", productcatalog);
            sd.Add("productdesc", productdesc);
            sd.Add("productname", productname);
            sd.Add("transtime", transtime);
            sd.Add("userip", userip);
            sd.Add("callbackurl", WebConfigurationManager.AppSettings["twiceAlipay"] + "/YeepayCallBack.aspx");
            sd.Add("fcallbackurl", WebConfigurationManager.AppSettings["twiceAlipay"] + "/YeepayFcallBack.aspx");
            sd.Add("userua", userua);
            string sign = EncryptUtil.handleRSA(sd, merchantPrivatekey);
            sd.Add("sign", sign);
            string wpinfo_json = Newtonsoft.Json.JsonConvert.SerializeObject(sd);
            string datastring = AES.Encrypt(wpinfo_json, merchantAesKey);
            string encryptkey = RSAFromPkcs8.encryptData(merchantAesKey, yibaoPublickey, "UTF-8");
            string postParams = "data=" + HttpUtility.UrlEncode(datastring) + "&encryptkey=" + HttpUtility.UrlEncode(encryptkey) + "&merchantaccount=" + merchantAccount;
            return postParams;
        }
        #endregion
        #region 易宝绑卡支付的处理函数
        public void HandleBindPay(string orderId, Decimal money, string bind)
        {
            DataTable dt = new OrderBLL().GetOrderById(orderId);
            Model.Orders orders = new OrderBLL().GetModel(orderId);
            DataTable rentCar = new RentCarBLL().GetCarDetail(Convert.ToInt32(dt.Rows[0]["rentCarID"]));
            int amount =Convert.ToInt32((money * 100));
            string bindid = bind;
            int currency = 156;
            string identityid = dt.Rows[0]["userID"].ToString();
            int identitytype = 0;
            string YeePayID2 = "";
            if (orders.YeePayID2 == "")
            {
                if (orders.YeePayID == "")
                {
                    YeePayID2 = "0";
                }
                else
                {
                    YeePayID2 = (Convert.ToInt32(dt.Rows[0]["YeePayID"]) + 1).ToString();
                }
            }
            else
            {
                YeePayID2 = (Convert.ToInt32(dt.Rows[0]["YeePayID2"]) + 1).ToString();
            }
            orders.YeePayID2 = YeePayID2;
            new OrderBLL().upDateAllByModule(orders);
            string orderid = orderId + "x" + YeePayID2;
            string other = dt.Rows[0]["passengerPhone"].ToString();
            string productcatalog = "1";
            string productdesc = "爱易租用车服务";
            string productname = "爱易租用车服务" + "——" + rentCar.Rows[0]["name"].ToString() + "（" + rentCar.Rows[0]["typeName"].ToString() + "）";
            DateTime t1 = DateTime.Now;
            DateTime t2 = new DateTime(1970, 1, 1);
            double t = t1.Subtract(t2).TotalSeconds;
            int transtime = (int)t;//交易时间
            string userip = Request.UserHostAddress;
            int terminaltype = 0;
            String terminalid = "00-10-5C-AD-72-E3";
            YJPay yjpay = new YJPay();
            //step1:调用sdk请求一键支付接口
            string payres = yjpay.bindPayRequest(bindid, amount, currency, identityid, identitytype, orderid, other,
                productcatalog, productdesc, productname, transtime, userip, WebConfigurationManager.AppSettings["twiceAlipay"] + "/YeepayCallBack.aspx", WebConfigurationManager.AppSettings["twiceAlipay"] + "/YeepayFcallBack.aspx", terminaltype, terminalid);
            //将支付请求获得的易宝返回结果反序列化
            SortedDictionary<string, object> payresSD = (SortedDictionary<string, object>)Newtonsoft.Json.JsonConvert.DeserializeObject(payres, typeof(SortedDictionary<string, object>));
            string validatecodejson = yjpay.sendValidateCode(orderid);
            Response.Redirect("/twicepay/BindCardPay.aspx?orderId=" + orderId);
        }
        #endregion

        #region 银联支付手机二次支付
        public void HandleUPMP(string orderID, decimal money)
        {
            // 请求要素
            Dictionary<String, String> req = new Dictionary<String, String>();
            req["version"] = UpmpConfig.GetInstance().VERSION;// 版本号
            req["charset"] = UpmpConfig.GetInstance().CHARSET;// 字符编码
            req["transType"] = "01";// 交易类型
            req["merId"] = UpmpConfig.GetInstance().MER_ID;// 商户代码
            req["backEndUrl"] = UpmpConfig.GetInstance().MER_BACK_END_URL;// 通知URL
            req["frontEndUrl"] = UpmpConfig.GetInstance().MER_FRONT_END_URL;// 前台通知URL(可选)
            req["orderDescription"] = " ";// 订单描述(可选)
            req["orderTime"] = DateTime.Now.ToString("yyyyMMddhhmmss");// 交易开始日期时间yyyyMMddHHmmss
            req["orderTimeout"] = "";// 订单超时时间yyyyMMddHHmmss(可选)
            req["orderNumber"] = orderID+"00";// 订单号(商户根据自己需要生成订单号)
            req["orderAmount"] = Convert.ToInt32(money * 100).ToString();// 订单金额 以分为单位
            req["orderCurrency"] = "156";// 交易币种(可选)
            req["reqReserved"] = " ";// 请求方保留域(可选，用于透传商户信息)

            // 保留域填充方法
            Dictionary<String, String> merReservedMap = new Dictionary<String, String>();
            merReservedMap["test"] = "付款"; //原来此处为 测试
            req["merReserved"] = UpmpService.BuildReserved(merReservedMap);// 商户保留域(可选)

            Dictionary<String, String> resp = new Dictionary<String, String>();
            bool validResp = UpmpService.Trade(req, resp);

            // 商户的业务逻辑
            if (validResp)
            {
                string url = WebConfigurationManager.AppSettings["paybackUrl"].ToString() + "/twicepay/HandleTwicePay.aspx?orderId=" + orderID + "&argName=";
                paydata = "tn=" + resp["tn"] + ",resultURL=" + HttpUtility.UrlEncode(url) + ",usetestmode=false";

                //paydata += "tn=" + resp["tn"] + ",resultURL=http%3A%2F%2Fwww.iezu.cn%2Ftwicepay%2FTwicePaySuccess.aspx%3ForderId%3D"+orderID+"%26argName%3D,usetestmode=false";   

                byte[] bytes = Encoding.Default.GetBytes(paydata);
                paydata = Convert.ToBase64String(bytes);
            
                Session["paydata"] = paydata;
                Response.Redirect("HandleUpmp.aspx");

            }
            else
            {
                // 服务器应答签名验证失败
                foreach (String key in resp.Keys)
                {
                    Response.Write(key + ":" + resp[key] + "<br>");
                }
            }
        }
        #endregion
        
    }
}