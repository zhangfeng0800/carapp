using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BLL;

namespace WebApp.twicepay
{
    public partial class TwicePayLoading : System.Web.UI.Page
    {
        public string orderId = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["orderId"] != null)
                {
                    string Id = Request.QueryString["orderId"].ToString();
                    DataTable dt = new OrderBLL().GetOrderById(Id);
                    if (dt.Rows.Count == 0)
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    string orderdate = Convert.ToDateTime(dt.Rows[0]["orderdate"].ToString()).ToString("yyyyMMddHHmmss");
                    if (orderdate != Id.Substring(0, Id.Length - 5))
                    {
                        Response.Redirect("/twicepay/error.aspx");
                        return;
                    }
                    DataTable mem = new OrderBLL().GetMemByOrderId(Id);
                    //payStatus.InnerText = "已付款";
                    totalFee.InnerText =Math.Round(float.Parse(dt.Rows[0]["totalMoney"].ToString()),2) + "元";
                    member.InnerText = mem.Rows[0]["username"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                    passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                    orderId = Id;
                }
                else
                {
                    Response.Redirect("/twicepay/error.aspx");
                    return;
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
         
        }
    }
}