using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using BLL;
using Model;
using DBUtility;
namespace WebApp.twicepay
{
    public partial class BindCardPay : System.Web.UI.Page
    {
        public string order = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["orderId"] != null)
                {
                    string orderId = Request.QueryString["orderId"].ToString();
                    order = orderId;
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
                    DataTable mem = new OrderBLL().GetMemByOrderId(orderId);
                    UserAccount objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    payStatus.InnerText = "未付款";
                    totalFee.InnerText = float.Parse(dt.Rows[0]["totalMoney"].ToString()) + "元";
                    unpaidMo.InnerText = float.Parse(dt.Rows[0]["unpaidMoney"].ToString()) + "元";
                    member.InnerText = mem.Rows[0]["compname"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                    passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                }
                if (Request.Form["checkCode"] != null)
                {
                    string code = Request.Form["checkCode"].ToString();
                    string orderId = Request.Form["order"].ToString();
                    order = orderId;
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
                    DataTable mem = new OrderBLL().GetMemByOrderId(orderId);
                    payStatus.InnerText = "付款处理中";
                    totalFee.InnerText = float.Parse(dt.Rows[0]["totalMoney"].ToString()) + "元";
                    unpaidMo.InnerText = float.Parse(dt.Rows[0]["unpaidMoney"].ToString()) + "元";
                    member.InnerText = mem.Rows[0]["username"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                    passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                    YJPay yjpay = new YJPay();
                    string confirmpayjson2 = yjpay.confirmPay(orderId + "x" + dt.Rows[0]["YeePayID2"].ToString(), code);
                    if (confirmpayjson2.Contains("error_code"))
                    {
                        this.codeError.Style["Display"] = "block";
                        this.submitLoading.Style["Display"] = "none";
                    }
                    else
                    {
                        Response.Redirect("/twicepay/TwicePayLoading.aspx?orderId=" + orderId);
                    }
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }
    }
}