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
    public partial class ActivitiesEdit : System.Web.UI.Page
    {
        private readonly ActivitiesBLL _activitiesBll=new ActivitiesBLL();
        protected Activities Model=new Activities();
        public Model.RentCar rentModel=new Model.RentCar();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _activitiesBll.GetModel(id);

            rentModel = (new RentCarBLL()).GetModel((int) Model.RentCarId);
            if (rentModel == null)
            {
                rentModel=new Model.RentCar();
            }
        }
    }
}