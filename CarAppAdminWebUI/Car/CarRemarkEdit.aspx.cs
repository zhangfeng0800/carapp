using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.Car
{
    public partial class CarRemarkEdit : System.Web.UI.Page
    {
        public CarRemark model;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                model = new CarRemarkBLL().GetModel(Request.QueryString["id"].ToString()) ?? new CarRemark();
            }
            else
            {
                model = new CarRemark();
            }

        }
    }
}