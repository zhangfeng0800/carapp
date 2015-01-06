using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;
using Newtonsoft.Json;
using System.Data;

namespace CarAppAdminWebUI.Car
{
    public partial class CarInfoEdit : System.Web.UI.Page
    {
        private readonly CarInfoBLL _carInfoBll=new CarInfoBLL();
        private readonly ServiceCityBLL _serviceCityBll=new ServiceCityBLL();
        protected CarInfo Model;
        protected string hotlineJson=string.Empty;
        protected DataTable brands;
        protected void Page_Load(object sender, EventArgs e)
        {
            brands = new BLL.CarBrandBLL().GetAllCarBrand();
            string id = Request.QueryString["id"];
            Model = _carInfoBll.GetModel(id);
            if (Model.CarUseWay == "A" && !string.IsNullOrEmpty(Model.HotLine))
            {
                var list = _serviceCityBll.GetList("id in (" + Model.HotLine + ")");
                hotlineJson = JsonConvert.SerializeObject(list);
            }
        }
        public DataTable GetCarBrandList()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Name", typeof (string));
            var rowone = dt.NewRow();
            rowone["Name"] = Model.Name;
            dt.Rows.Add(rowone);
            var list = new CarBrandBLL().GetAllCarBrand();

            foreach (DataRow row in list.Rows)
            {
                var rowtemp = dt.NewRow();
                if (row["brandName"].ToString() == Model.Name)
                    continue;
                rowtemp["Name"] = row["brandName"];
                dt.Rows.Add(rowtemp);
            }
            return dt;
        }
    }
}