using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Car
{
    public partial class RentCarAdd : System.Web.UI.Page
    {
        public DataTable data=new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            data = (new CarRemarkBLL()).GetDataTable();
        }

    }
}