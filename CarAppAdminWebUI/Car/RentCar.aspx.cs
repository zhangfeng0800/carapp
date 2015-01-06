using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BLL;

namespace CarAppAdminWebUI.Car
{
    public partial class RentCar : System.Web.UI.Page
    {
        public DataTable CarType = new DataTable();
        public List<Model.CarUseWay> Caruseway = new List<Model.CarUseWay>();
        protected void Page_Load(object sender, EventArgs e)
        {
            CarType = (new CarTypeBLL()).GetDataTable();
            Caruseway = new CarUseWayBLL().GetAllCarUseWay();
        }
    }
}