using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using com.yeepay;
using IEZU.Log;

namespace WebApp
{
    public partial class TwiceYeePayReturn : System.Web.UI.Page
    {
        public string orderID = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分
                Buy.logstr(FormatQueryString.GetQueryString("r6_Order"), Request.Url.Query, "");
                BuyCallbackResult result = Buy.VerifyCallback(FormatQueryString.GetQueryString("p1_MerId"), FormatQueryString.GetQueryString("r0_Cmd"), FormatQueryString.GetQueryString("r1_Code"), FormatQueryString.GetQueryString("r2_TrxId"),
                FormatQueryString.GetQueryString("r3_Amt"), FormatQueryString.GetQueryString("r4_Cur"), FormatQueryString.GetQueryString("r5_Pid"), FormatQueryString.GetQueryString("r6_Order"), FormatQueryString.GetQueryString("r7_Uid"),
                FormatQueryString.GetQueryString("r8_MP"), FormatQueryString.GetQueryString("r9_BType"), FormatQueryString.GetQueryString("rp_PayDate"), FormatQueryString.GetQueryString("hmac"));
                if (string.IsNullOrEmpty(result.ErrMsg))
                {
                    if (result.R1_Code == "1")
                    {
                        string r6_Order = result.R6_Order;
                        r6_Order = r6_Order.Split('_')[0];
                        string r3_Amt = result.R3_Amt;
                        string rp_PayDate = result.Rp_PayDate;
                        string r8_MP = result.R8_MP;
                        Model.Account objAccount = new Model.Account();
                        Model.Orders order = new BLL.OrderBLL().GetModel(r6_Order);
                        Model.UserAccount user = new BLL.UserAccountBLL().GetModel(order.userID);
                        Model.UserAccount masterUser = new BLL.UserAccountBLL().GetMaster(order.userID);//个人账户与集团下属个人账户信息
                        Model.CarInfo car = new BLL.CarInfoBLL().GetModel(order.carId);
                        if (order.orderStatusID == (int)Common.OrderStatus.二次付款)
                        {
                            if (result.R9_BType == "1")//同步
                            {
                                orderID = r6_Order;
                            }
                            else//异步
                            {
                                int res = new BLL.AccountBLL().DealPayNotify(2, Common.Action.BANKUNION, r6_Order,
                                                                                Convert.ToDecimal(r3_Amt));
                                
                            }
                        }
                    }
                    else
                    {
                        Response.Write("支付失败!");
                        Response.End();
                    }
                }
                else
                {
                    Response.Write("交易签名无效!");
                    Response.End();
                }
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }
    }
}