using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace WebApp
{
    public partial class AccountpaySuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["orderid"] == null)
                {
                    Response.Write("<script>alert('参数错误');location='/default.aspx'</script>");
                }
                else
                {
                    var orderid = Request.QueryString["orderid"];
                    var orderModel = (new OrderBLL()).GetModel(orderid);
                    if (orderModel == null)
                    {
                        Response.Write("<script>alert('订单不存在！');location='/default.aspx'</script>");
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