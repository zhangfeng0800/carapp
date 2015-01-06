using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BLL;
using Model;

namespace WebApp.twicepay
{
    public partial class TwicePayBind : System.Web.UI.Page
    {
        public string orderId = "";
        protected Model.OrdersExtInfo orderExt = new Model.OrdersExtInfo();

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
                    orderExt = new BLL.OrdersExtInfo().GetModel(dt.Rows[0]["orderID"].ToString());
                    if (orderExt == null)
                    {
                        orderExt = new Model.OrdersExtInfo();
                        orderExt.overMinut = 0;
                        orderExt.overMinutMoney = 0.00M;
                        orderExt.overKM = 0;
                        orderExt.overKMMoney = 0.00M;
                        orderExt.highwayMoney = 0.00M;
                        orderExt.carStopMoney = 0.00M;
                        orderExt.airportMoney = 0.00M;
                        orderExt.emptyCarMoney = 0.00M;
                    }
                    UserAccount objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    if (Convert.ToInt32(dt.Rows[0]["orderStatusID"]) == 6 && Convert.ToInt32(dt.Rows[0]["paystatus"]) == 1)
                    {
                        Response.Redirect("/twicepay/TwicePaySuccess.aspx?orderId=" + Id);
                    }
                    else
                    {
                        payStatus.InnerText = "未付款";
                        totalFee.InnerText = float.Parse(dt.Rows[0]["totalMoney"].ToString()) + "元";
                        unpaidMo.InnerText = float.Parse(dt.Rows[0]["unpaidMoney"].ToString()) + "元"; ;
                        member.InnerText = mem.Rows[0]["username"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                        passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                        blance.InnerText = objUser.Balance.ToString() + "元";
                    }
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