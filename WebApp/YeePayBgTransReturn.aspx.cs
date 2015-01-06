using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using com.yeepay;
using System.Data;
using System.Data.SqlClient;
using Common;
using IEZU.Log;
using Model;
using BLL;
namespace WebApp
{
    public partial class YeePayBgTransReturn : System.Web.UI.Page
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
            try
            {
                #region 处理部分

                if (!IsPostBack)
                {
                    Buy.logstr(FormatQueryString.GetQueryString("r6_Order"), Request.Url.Query, "");
                    BuyCallbackResult result = Buy.VerifyCallback(FormatQueryString.GetQueryString("p1_MerId"),
                        FormatQueryString.GetQueryString("r0_Cmd"),
                        FormatQueryString.GetQueryString("r1_Code"),
                        FormatQueryString.GetQueryString("r2_TrxId"),
                        FormatQueryString.GetQueryString("r3_Amt"),
                        FormatQueryString.GetQueryString("r4_Cur"),
                        FormatQueryString.GetQueryString("r5_Pid"),
                        FormatQueryString.GetQueryString("r6_Order"),
                        FormatQueryString.GetQueryString("r7_Uid"),
                        FormatQueryString.GetQueryString("r8_MP"),
                        FormatQueryString.GetQueryString("r9_BType"),
                        FormatQueryString.GetQueryString("rp_PayDate"),
                        FormatQueryString.GetQueryString("hmac"));
                    if (string.IsNullOrEmpty(result.ErrMsg))
                    {
                        if (result.R1_Code == "1")
                        {
                            string r6_Order = result.R6_Order;
                            if (r6_Order.Contains('_'))
                            {
                                r6_Order = r6_Order.Split('_')[0];
                            }
                            string r3_Amt = result.R3_Amt;
                            string rp_PayDate = result.Rp_PayDate;
                            string r8_MP = result.R8_MP;
                            Account objAccount = new Account();
                            UserAccount objUser;
                            if (r8_MP.Equals("order"))
                            {

                                int res = new BLL.AccountBLL().DealPayNotify(0, Common.Action.BANKUNION, r6_Order,
                                    Convert.ToDecimal(r3_Amt));
                                if (res == 1)
                                {
                                    tip.InnerText = "恭喜您，订单支付成功！";
                                    orderTip.InnerText = "感谢您选择爱易租用车服务，调配中心正在调配您预订的车辆，请稍候";
                                    payType.InnerText = "您的订单号是：";
                                    orderNum.InnerText = r6_Order;
                                    memCenter.InnerText = "您可以登录个人中心查看订单、账户余额与流水详情";
                                    　
                                }
                                else
                                {
                                    tip.InnerText = "订单支付失败！";
                                    orderTip.InnerText = "";
                                    payType.InnerText = "您的订单号是：";
                                    orderNum.InnerText = r6_Order;
                                    memCenter.InnerText = "";
                                    LogHelper.WriteOperation("查询订单号为[" + r6_Order + "]", OperationType.Query, "查询失败");
                                    return;
                                }
                            }
                            else if (r8_MP.Equals("recharge"))
                            {
                                int res = new BLL.AccountBLL().DealPayNotify(1, Common.Action.BANKUNION, r6_Order,
                                    Convert.ToDecimal(r3_Amt));
                                if (res == 1)
                                {
                                    tip.InnerText = "恭喜您，充值成功！";
                                    orderTip.InnerText = "感谢您选择爱易租用车服务，更多充值，更多惊喜";
                                    payType.InnerText = "您的充值单号是：";
                                    orderNum.InnerText = r6_Order;
                                    memCenter.InnerText = "您可以登录个人中心查看充值、账户余额与流水详情";
                                }
                                else
                                {
                                    tip.InnerText = "充值失败！";
                                }
                            }

                            else
                            {
                                Response.Write("SUCCESS"); 
                            }
                        }
                        else
                        {
                            Response.Write("支付失败!");
                           
                        }
                    }
                    else
                    {
                        Response.Write("交易签名无效!");
                    }
                }

                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
            finally
            {
                Response.End();
            }

        }
    }
}