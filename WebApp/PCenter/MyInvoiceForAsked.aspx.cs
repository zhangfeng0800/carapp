using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;
using BLL;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyInvoiceForAsked : PageBase.PageBase
    {
        protected DataTable invoList = new DataTable();
        protected int pageCount = 1;
        protected const int PageSize = 10;
        protected int rowCount = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!string.IsNullOrEmpty(Request["pageIndex"]))
            {
              
                invoList = new BLL.OrderInvoiceBll().GetOrderInvoicePage(-1, userAccount.Id, 6, "", PageSize, Convert.ToInt32(Request["pageIndex"]),
                                                                    out rowCount);
                Response.Write(JsonConvert.SerializeObject(invoList));
                Response.End();
            }
            else
            {
                invoList = new BLL.OrderInvoiceBll().GetOrderInvoicePage(-1, userAccount.Id, 6, "", PageSize, 1,
                                                                 out rowCount);
            }
            pageCount = (int)Math.Ceiling(rowCount / Convert.ToDecimal(PageSize));


        }
    }
}