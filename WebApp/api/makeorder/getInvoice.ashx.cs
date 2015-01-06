using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Model;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getInvoice 的摘要说明
    /// </summary>
    public class getInvoice : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var data = new DataTable();
            UserAccount ua = new UserAccount();
            InvoiceBLL invoice = new InvoiceBLL();
            if (context.Session["UserInfo"] == null)
            {
                return;
            }
            ua = (UserAccount)context.Session["UserInfo"];
            if (ua.Type == 1 || ua.Type == 2)
            {
                data = invoice.GetDataTableByUser((new UserAccountBLL()).GetMaster(ua.Id).Id);
            }
            else
            {
                data = invoice.GetDataTableByUser(ua.Id);
            }
            if (data.Rows.Count > 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    data = data,
                    CodeId = 1
                }));
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    CodeId = 0
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