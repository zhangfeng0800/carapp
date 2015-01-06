using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using BLL.HandlePayUtilBll;
using Common;
using IEZU.Log;
using Model;
using System.Web.Configuration;
using Com;

namespace WebApp
{
    public partial class PC_HandleTwicePay : PageBase.PageBase
    {
        public UserAccount user;
        public UserAccount masterUser;
        public Orders order;
        public Model.CarInfo car;

        #region 银联无卡支付字段代码
        public string MerId = "";
        public string OrderId = "";//订单编号16位长度
        public string Amount = "";//金额12位长度，左端补0
        public string CuryId = "";//订单交易币种.人民币156
        public string Date = "";//订单时间，格式：YYYYMMDD
        public string BackUrl = WebConfigurationManager.AppSettings["paybackUrl"] + "/UpopCallback.aspx";
        public string SignStr = "";
        public string Idext = "";
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Request.Form.Count > 0)
                {
                    user = Session["userInfo"] as Model.UserAccount;
                    string payType = Request.Form["payType"];
                    string orderId = Request.Form["orderid"].ToString().Trim();
                    //string useaccount = Request.Form["useaccount"].ToString();//可以作为私有域传给第三方，确保付款无误（暂未使用）
                    string bankid = Request.Form["bankid"];
                    string isBalance = Request.Form["ifbalance"];
                    order = new OrderBLL().GetModel(orderId);
                    car = new BLL.CarInfoBLL().GetModel(order.carId);
                    masterUser = new UserAccountBLL().GetMaster(user.Id);
                    HanlePay(payType, orderId, bankid, isBalance);
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }

        }

        public void HanlePay(string payType, string orderId, string bankid, string isBalance)
        {
            try
            {
                HandlePayBLL handlePayBll = new HandlePayBLL();
                string money = "0";
                var yeepayid = 0;
                var isaccountenough = 0;
                handlePayBll.HandleTwicePay(orderId, isBalance, out money, out yeepayid, out isaccountenough);
                
                if (isBalance == "1")//使用账户余额
                {
                    if (isaccountenough==1)
                    {
                        BalanceAll(orderId);
                    }
                    else
                    {
                        if (payType == "unionpay") //银联支付
                        {
                            HanleUpopPay("twicePay", orderId, money);
                            return;
                        }
                        if (bankid.Trim().Length > 0 && payType.ToLower() == "yeepay")//易宝
                        {
                           
                            GoYeePay(orderId + "_" + yeepayid.ToString(), money, bankid);
                        }
                        else//支付宝
                        { 
                            GoApliPay(orderId + "_" + yeepayid.ToString(), money);
                        }
                    }
                }
                else//不使用余额支付
                {
                    
                    if (payType == "unionpay") //银联支付
                    {
                        HanleUpopPay("twicePay", orderId, money);
                        return;
                    }
                    if (bankid.Trim().Length > 0 && payType.ToLower() == "yeepay")//易宝
                    { 
                        GoYeePay(orderId + "_" +yeepayid.ToString(), money, bankid);
                    }
                    else//支付宝
                    {
                       
                        GoApliPay(orderId + "_" +yeepayid.ToString(), money);
                    }
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex); 
                Response.Write(ex.Message);
            }

        }


        #region 银联支付代码
        public void HanleUpopPay(string style, string orderID, string money)
        {
            NetPay netpay = new NetPay();
            string path = Server.MapPath("App_Data/MerPrK_808080201304188_20140618154302.key");
            MerId = "808080201304188";
            netpay.buildKey(MerId, 0, path);
            if (netpay.PrivateKeyFlag)
            {
                orderID = "02" + orderID; //二次支付
                OrderId = orderID.Substring(0, 16);
                Idext = orderID.Substring(16);
                Amount = Convert.ToInt32(Convert.ToDecimal(money) * 100).ToString(); //要求为12位，不够的左端补0;
                if (Amount.Length < 12)
                {
                    int num = 12 - Amount.Length;
                    string zero = "";
                    for (int i = 0; i < num; i++)
                    {
                        zero += "0";
                    }
                    Amount = zero + Amount;
                }
                CuryId = "156";
                Date = DateTime.Now.ToString("yyyyMMdd");
                SignStr = netpay.Sign(MerId + OrderId + Amount + CuryId + Date + "0001" + Idext);
            }
        }
        #endregion

        #region 支付宝代码
        public string _sign_type = Com.Alipay.Config.Sign_type.Trim().ToUpper();
        public string _key = Com.Alipay.Config.Key.Trim();
        public string _input_charset = Com.Alipay.Config.Input_charset.Trim().ToLower();
        public void GoApliPay(string orderid, string money)
        {
            SortedDictionary<string, string> sParaTemp = new SortedDictionary<string, string>();
            sParaTemp.Add("service", "create_direct_pay_by_user");
            //sParaTemp.Add("service", " trade_create_by_buyer");
            sParaTemp.Add("partner", Com.Alipay.Config.Partner);
            sParaTemp.Add("_input_charset", Com.Alipay.Config.Input_charset.ToLower());
            sParaTemp.Add("notify_url", WebConfigurationManager.AppSettings["paybackUrl"] + "/TwiceAliPayReturn.aspx");
            sParaTemp.Add("return_url", WebConfigurationManager.AppSettings["paybackUrl"] + "/PC_TwicePaySuccess.aspx?orderid=" + orderid);
            //业务参数
            sParaTemp.Add("out_trade_no", orderid);
            sParaTemp.Add("subject", "爱易租订单二次付款");
            sParaTemp.Add("payment_type", "1");
            sParaTemp.Add("logistics_type", "EXPRESS");
            sParaTemp.Add("logistics_fee", "0.00");
            sParaTemp.Add("logistics_payment", "SELLER_PAY");
            sParaTemp.Add("seller_email", "hbfangrun@126.com");
            sParaTemp.Add("price", money);
            sParaTemp.Add("quantity", "1");
            sParaTemp.Add("body", "twicePay");
            Dictionary<string, string> dicPara = new Dictionary<string, string>();

            dicPara = BuildRequestPara(sParaTemp);
            if (dicPara.Count != 0)
            {
                HttpContext.Current.Response.Write("<form name='alipayForm' method='get' action='https://mapi.alipay.com/gateway.do?_input_charset=utf-8'>");
                foreach (KeyValuePair<string, string> temp in dicPara)
                {
                    HttpContext.Current.Response.Write("<input type='hidden' name='" + temp.Key + "' value='" + temp.Value + "'/>");
                }
                HttpContext.Current.Response.Write("<script>");
                HttpContext.Current.Response.Write("document.alipayForm.submit();");
                HttpContext.Current.Response.Write("</script></form>");
            }
        }
        public Dictionary<string, string> BuildRequestPara(SortedDictionary<string, string> sParaTemp)
        {
            //待签名请求参数数组
            Dictionary<string, string> sPara = new Dictionary<string, string>();
            //签名结果
            string mysign = "";

            //过滤签名参数数组
            sPara = Com.Alipay.Core.FilterPara(sParaTemp);

            //获得签名结果
            mysign = BuildRequestMysign(sPara);

            //签名结果与签名方式加入请求提交参数组中
            sPara.Add("sign", mysign);
            sPara.Add("sign_type", _sign_type);

            return sPara;
        }
        public string BuildRequestMysign(Dictionary<string, string> sPara)
        {
            //把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
            string prestr = Core.CreateLinkString(sPara);

            //把最终的字符串签名，获得签名结果
            string mysign = "";
            switch (_sign_type)
            {
                case "MD5":
                    mysign = AlipayMD5.Sign(prestr, _key, _input_charset);
                    break;
                default:
                    mysign = "";
                    break;
            }
            return mysign;
        }
        #endregion
        #region 易宝支付代码
        public void GoYeePay(string orderid, string money, string bankID)
        {
            string info = "爱易租订单二次付款";
            string hmac = com.yeepay.Buy.CreateBuyHmac(orderid, money, "CNY", info, "", "", WebConfigurationManager.AppSettings["paybackUrl"] + "/TwiceYeePayReturn.aspx", "0", "twicePay", bankID, "1");
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
            HttpContext.Current.Response.Write("<form name='yeepayForm' method='post' action='" + com.yeepay.Buy.GetBuyUrl() + "'>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p0_Cmd' value='Buy' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='p1_MerId' value='" + com.yeepay.Buy.GetMerId() + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p2_Order' value='" + orderid + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p3_Amt'  value='" + money + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p4_Cur' value='CNY' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='p5_Pid' value='" + info + "'/>");//商品名称
            HttpContext.Current.Response.Write("<input type='hidden' name='p6_Pcat' value=''/>");//商品种类
            HttpContext.Current.Response.Write("<input type='hidden' name='p7_Pdesc' value=''/>");//商品描述
            HttpContext.Current.Response.Write("<input type='hidden' name='p8_Url' value='" + WebConfigurationManager.AppSettings["paybackUrl"] + "/TwiceYeePayReturn.aspx" + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p9_SAF' value='0' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='pa_MP'  value='" + "twicePay" + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='pd_FrpId' value='" + bankID + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='pr_NeedResponse' value='1'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='hmac'  value='" + hmac + "'/>");
            HttpContext.Current.Response.Write("<script>");
            HttpContext.Current.Response.Write("document.yeepayForm.submit();");
            HttpContext.Current.Response.Write("</script></form>");
        }
        #endregion
        #region 全部余额支付代码
        public void BalanceAll(string orderid)
        {
            int result = new BLL.AccountBLL().DealPayNotify(2, Common.Action.PAYORDER, orderid, 0);
          
            Session["UserInfo"] = new UserAccountBLL().GetModel(user.Id);
            Response.Redirect("PC_TwicePaySuccess.aspx?orderid=" + orderid);
        }

        #endregion

    }
}