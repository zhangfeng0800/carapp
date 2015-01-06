using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// SaveInvoice 的摘要说明
    /// </summary>
    public class SaveInvoice : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var httpCookie = context.Request.Cookies[0];
            if (context.Request.Form["invoiceType"] != null && context.Request.Form["invoiceHead"] != null &&
                context.Request.Form["invoiceAdress"] != null && context.Request.Form["invoiceZipCode"] != null &&
                httpCookie != null && (context.Request.Headers["sid"] != null &&
                    context.Request.Headers["weblogid"] == httpCookie.Value))
            {
                var userid = int.Parse(EncryptAndDecrypt.Decrypt(context.Request.Headers["sid"]));
                var bll = new InvoiceBLL();
                var result = bll.InsertData(new Invoice
                   {
                       InvoiceType =Convert.ToInt32(context.Request.Form["invoiceType"]),
                       InvoiceHead = context.Request.Form["invoiceHead"],
                       InvoiceAdress = context.Request.Form["invoiceAdress"],
                       InvoiceZipCode = context.Request.Form["invoiceZipCode"],
                       UserId = userid
                   });
                context.Response.Write(result > 0
                    ? JsonConvert.SerializeObject(new { result = "0", message = "保存成功" })
                    : JsonConvert.SerializeObject(new { result = "1", message = "保存失败" }));
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}