using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using BLL;
using IEZU.Log;
using Model;
using Common;

namespace WebApp
{
    public partial class UpopCallback : System.Web.UI.Page
    {

        public string Username { get; set; }
        public int IsLogined { get; set; }
        protected bool IsRedirect { get; set; }
        protected Model.UserAccount userAccount = new Model.UserAccount();
        protected override void OnInit(EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                IsLogined = 0;
                Username = "游客";
            }
            else
            {
                userAccount = Session["UserInfo"] as Model.UserAccount;
                IsLogined = 1;
                Username = userAccount.Username;
            }
            base.OnInit(e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            NetPay netpay = new NetPay();
           
　　        //初始化key文件：
            string path = Server.MapPath("App_Data/PgPubk.key");
            netpay.buildKey("999999999999999", 0, path);//设置公钥        

            if (netpay.PublicKeyFlag)
            {
                if (Request.Form["status"] == "1001") //使用版本：20070129
                {
                    string merId = Request.Form["merid"];
                    string ordId = Request.Form["orderno"];
                    string transAmt = Request.Form["amount"];
                    string curyId = Request.Form["currencycode"];
                    string transDate = Request.Form["transdate"];
                    string transType = Request.Form["transtype"];
                    string status = Request.Form["status"];
                    string Priv1 = Request.Form["Priv1"];


                    bool flag = netpay.verifyTransResponse(merId, ordId, transAmt, curyId, transDate, transType, status,
                                                           Request.Form["checkvalue"]); // ChkValue为ChinaPay应答传回的域段

                    LogHelper.WriteOperation("访问PC银联支付接受页面,flag:" + flag, OperationType.Update, "成功");

                    if (flag)
                    {
                        string stype = ordId.Substring(0,2);
                        string out_trade_no = ordId.Substring(2) + Priv1; 
                        

                        decimal total_fee =  Convert.ToDecimal(transAmt)/100;


                        Model.Account objAccount = new Model.Account();

                        #region 分支一： 支付订单

                        if (stype == "00") //支付订单
                        {
                            int result = new BLL.AccountBLL().DealPayNotify(0, Common.Action.UPOP, out_trade_no,
                                                                            total_fee);
                            if (result == 1)
                            {
                                tip.InnerText = "恭喜您，订单支付成功！";
                                orderTip.InnerText = "感谢您选择爱易租用车服务，调配中心正在调配您预订的车辆，请稍候";
                                payType.InnerText = "您的订单号是：";
                                orderNum.InnerText = out_trade_no;
                                memCenter.InnerText = "您可以登录个人中心查看订单、账户余额与流水详情";
                               　
                                //Response.Write("success");
                                //Response.End();
                            }
                            else
                            {
                                tip.InnerText = "由于网络原因，未能收到支付结果，请到个人中心查看，如果失败，请联系客服！";
                            }
                        }
                            #endregion

                        #region 分支二：充值

                        else if (stype == "01") //充值
                        {
                            int result = new BLL.AccountBLL().DealPayNotify(1, Common.Action.UPOP, out_trade_no,
                                                                            total_fee);
                            if(result == 1)
                            {
                                tip.InnerText = "恭喜您，充值成功！";
                                orderTip.InnerText = "感谢您选择爱易租用车服务，更多充值，更多惊喜";
                                payType.InnerText = "您的充值单号是：";
                                orderNum.InnerText = out_trade_no;
                                memCenter.InnerText = "您可以登录个人中心查看充值、账户余额与流水详情";
                            }
                            else
                            {
                                tip.InnerText = "对不起，充值失败！";
                            }
                        }
                            #endregion

                        #region 分支三：二次付款

                        else if (stype == "02") //二次付款
                        {
                            int res = new BLL.AccountBLL().DealPayNotify(2, Common.Action.UPOP, out_trade_no,
                                                                         Convert.ToDecimal(total_fee));
                            if (res == 1)
                            {
                                tip.InnerText = "恭喜您，二次支付成功！";
                                orderTip.InnerText = "感谢您选择爱易租用车服务，更多充值，更多惊喜";
                                payType.InnerText = "您的订单单号是：";
                                orderNum.InnerText = out_trade_no;
                                memCenter.InnerText = "您可以登录个人中心查看充值、账户余额与流水详情";
                                
                            }
                            else
                            {
                                tip.InnerText = "二次支付失败！";
                            }
                        }

                        #endregion

                    }
                }
            }








            // 收到回应后做后续处理（这里写入文件，仅供演示）
            //System.IO.StreamWriter sw = new System.IO.StreamWriter(Server.MapPath("./notify_data.txt"));

            //if (resp.ResponseCode == SrvResponse.RESP_SUCCESS)
            //{
                
            //    string out_trade_no = resp.Fields["orderNumber"].ToString().Substring(2);

            //    string stype = resp.Fields["orderNumber"].ToString().Substring(0,2);

            //    float total_fee = float.Parse(resp.Fields["settleAmount"].ToString()) / 100;

              
                

            //    UserAccount objUser;
            //    Model.Account objAccount = new Model.Account();



           


            //}


            //foreach (string k in resp.Fields.Keys)
            //{
            //    sw.WriteLine(k + "\t = " + resp.Fields[k]);
            //}

            //DBUtility.SqlDbHelper Helper = new DBUtility.SqlDbHelper();
            //SqlParameter[] datas =
            //    {
            //        new SqlParameter("@key","银联"),
            //        new SqlParameter("@value",resp.Fields["orderNumber"]+"##"+resp.Fields["settleAmount"])
            //    };
            //Helper.Insert("insert into test values(@key,@value)", datas);


            // sw.Close(); 

        }
    }
}