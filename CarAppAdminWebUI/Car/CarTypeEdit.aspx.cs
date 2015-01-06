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
    public partial class CarTypeEdit : System.Web.UI.Page
    {
        private readonly CarTypeBLL _carTypeBll = new CarTypeBLL();
        protected DataRow dr;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            dr = _carTypeBll.GeTable(id).Rows[0];
        }
    }
}