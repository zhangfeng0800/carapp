using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getinvoicebyuser 的摘要说明
    /// </summary>
    public class getinvoicebyid : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["invoiceid"] != null)
            {
                var invoice = (new InvoiceBLL()).GetDataTable(int.Parse(context.Request.QueryString["invoiceid"]));
                if (invoice.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        ResultCode = 1,
                        invoiceType = invoice.Rows[0]["invoiceType"],
                        invoiceHead = invoice.Rows[0]["invoiceHead"],
                        invoiceAddress = invoice.Rows[0]["invoiceAdress"],
                        invoiceZipcode = invoice.Rows[0]["invoiceZipcode"],
                        invoiceClass = invoice.Rows[0]["invoiceclass"],
                        invoiceid=invoice.Rows[0]["id"].ToString()
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        ResultCode = 0
                    }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    ResultCode = 0
                }));
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