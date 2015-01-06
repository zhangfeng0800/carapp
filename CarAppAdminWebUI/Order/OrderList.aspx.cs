using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using NPOI.POIFS.Storage;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Order
{
    public partial class OrderList : System.Web.UI.Page
    {
        //public DataTable Data = new DataTable();
        public DataTable CarType = new DataTable();
        public string Exten="";
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                // Data = (new OrderBLL()).GetOrderUser();
                CarType = (new CarTypeBLL()).GetDataTable();
                if (Request.Cookies["exten"] != null)
                {
                    Exten = Request.Cookies["exten"].Value.ToString();
                }
            }
          
        }
    }
}