using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;
using BLL;

namespace WebApp.PCenter
{
    public partial class MyInvoice : PageBase.PageBase
    {
        protected List<Model.Invoice> invoices = new List<Model.Invoice>();

        protected void Page_Load(object sender, EventArgs e)
        {
            PersonCenter pCenter = (PersonCenter)this.Master;//权限
            pCenter.redirectMaster = userAccount.Popedom.InvoicePage;//权限
            invoices = new BLL.InvoiceBLL().GetList(userAccount.Id).OrderByDescending(s=>s.Id).ToList();
        }
    }
}