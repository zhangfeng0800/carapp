using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;
using BLL;

namespace WebApp
{
    public partial class TwicePay :PageBase.PageBase
    {
        public string paydata = "";
        public string orderId = "";
        public UserAccount objUser = new UserAccount();
        public Model.Orders order = new Orders();
        protected Model.OrdersExtInfo orderExt = new Model.OrdersExtInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string orderid = Request.QueryString["orderid"];
                order = new OrderBLL().GetModel(orderid);
                objUser = new UserAccountBLL().GetMaster(order.userID);
                if (Request.Form.Count > 0)
                {
                    string payType = Request.Form["payType"].ToString();
                    string orderId = Request.Form["orderpay"].ToString();
                    //string useaccount = Request.Form["useaccount"].ToString();//可以作为私有域传给第三方，确保付款无误（暂未使用）
                    var addMo = Request.Form["addMo"].ToString();
                    string wgId = Request.Form["wgId"].ToString();
                    string style = Request.Form["style"];
                    //HanlePay(payType, orderId, addMo, wgId, style);
                }
                orderExt = new BLL.OrdersExtInfo().GetModel(order.orderId);
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
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
          
        }
    }
}