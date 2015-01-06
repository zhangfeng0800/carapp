using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.yeepay;
using System.Web.Configuration;
namespace WebApp
{
    public class yeepaySubmit
    {
        public void GoToPay(string orderCode, string money,string wgId,string serviceInfo,string style)
        {
            string info = serviceInfo;
            string hmac = Buy.CreateBuyHmac(orderCode, money, "CNY", info, "", "", WebConfigurationManager.AppSettings["paybackUrl"] + "/YeePayBgTransReturn.aspx", "0", style, wgId, "1");
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
            HttpContext.Current.Response.Write("<form name='yeepayForm' method='post' action='" + Buy.GetBuyUrl() + "'>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p0_Cmd' value='Buy' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='p1_MerId' value='" + Buy.GetMerId() + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p2_Order' value='" + orderCode + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p3_Amt'  value='" + money + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p4_Cur' value='CNY' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='p5_Pid' value='" +info+ "'/>");//商品名称
            HttpContext.Current.Response.Write("<input type='hidden' name='p6_Pcat' value=''/>");//商品种类
            HttpContext.Current.Response.Write("<input type='hidden' name='p7_Pdesc' value=''/>");//商品描述
            HttpContext.Current.Response.Write("<input type='hidden' name='p8_Url' value='" + WebConfigurationManager.AppSettings["paybackUrl"] + "/YeePayBgTransReturn.aspx" + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='p9_SAF' value='0' />");
            HttpContext.Current.Response.Write("<input type='hidden' name='pa_MP'  value='" + style + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='pd_FrpId' value='" + wgId + "'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='pr_NeedResponse' value='1'/>");
            HttpContext.Current.Response.Write("<input type='hidden' name='hmac'  value='" + hmac + "'/>");
            HttpContext.Current.Response.Write("<script>");
            HttpContext.Current.Response.Write("document.yeepayForm.submit();");
            HttpContext.Current.Response.Write("</script></form>");
        }
    }
}