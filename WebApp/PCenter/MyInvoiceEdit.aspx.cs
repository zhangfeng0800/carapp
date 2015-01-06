using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using IEZU.Log;
using Model;

namespace WebApp.PCenter
{
    public partial class MyInvoiceEdit : System.Web.UI.Page
    {
        public int invoiceid;
        public DataTable data;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                invoiceid = int.Parse(Request.QueryString["id"]);
                var invoicebll = new InvoiceBLL();
                data = invoicebll.GetInvoicData(invoiceid);
                if (data.Rows.Count == 0)
                {
                    Response.Redirect("MyInvoice.aspx");
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                Response.Redirect("MyInvoice.aspx");
            }
          
        }
    }
}