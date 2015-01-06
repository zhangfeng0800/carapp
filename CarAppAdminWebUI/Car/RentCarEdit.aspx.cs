using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;
using Model;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Car
{
    public partial class RentCarEdit : System.Web.UI.Page
    {
        protected Model.RentCar Model;
        protected string CarBrand = string.Empty;
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        public DataTable data=new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            Model = _rentCarBll.GetModel(id);
            var list = _carBrandBll.GetAllBrandByRentID(id);
            foreach (DataRow dr in list.Rows)
            {
                CarBrand += dr["id"].ToString() + ",";
            }
            if (!string.IsNullOrEmpty(CarBrand))
            {
                CarBrand = CarBrand.Substring(0, CarBrand.Length - 1);
            }
            data = (new CarRemarkBLL()).GetDataTable();
        }

        protected int Get(decimal min, string key)
        {
            int res = 0;
            switch (key)
            {
                case "h":
                    if (min >= 60)
                    {
                        res = Convert.ToInt32(min / 60);
                    }
                    break;
                case "m":
                    res = min < 60 ? Convert.ToInt32(min) : Convert.ToInt32(min % 60);
                    break;
            }
            return res;
        } 
    }
}