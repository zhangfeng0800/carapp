using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.Car
{
    public partial class DriverEdit : System.Web.UI.Page
    {
        private readonly DirverAccountBLL _dirverAccountBll = new DirverAccountBLL();
        protected DriverAccount Model = new DriverAccount();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _dirverAccountBll.GetModel(id);
        }

        public string GetDate(string date)
        {
            if (string.IsNullOrEmpty(date))
            {
                return  new DateTime().ToString("yyyy-MM-dd");
            }
            var datetime = new DateTime();
            if (!DateTime.TryParse(date, out datetime))
            {
                return DateTime.Now.ToString("yyyy-MM-dd");
            }
            return datetime.ToString("yyyy-MM-dd");
        }
    }
}