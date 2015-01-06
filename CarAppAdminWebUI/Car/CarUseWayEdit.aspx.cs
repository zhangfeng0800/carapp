using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.Car
{
    public partial class CarUseWayEdit : System.Web.UI.Page
    {
        protected Model.CarUseWay Model;
        private readonly CarUseWayBLL _carUseWayBll = new CarUseWayBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _carUseWayBll.GetCarUseWayModel(id);
        }
    }
}