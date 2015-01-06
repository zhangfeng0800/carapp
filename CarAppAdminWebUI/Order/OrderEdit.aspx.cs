using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace CarAppAdminWebUI.Order
{
    public partial class OrderEdit : System.Web.UI.Page
    {
        private readonly OrderBLL _orderBll=new OrderBLL();
        protected Orders Model;
        protected string startCityName;
        protected string endCityName;
        protected int caruseway;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (string.IsNullOrEmpty(id))
            {
                ShowError();
                return;
            }
            Model = _orderBll.GetModel(id);

            startCityName = (new CityBLL()).GetFullResult(Model.departureCityID).Rows[0]["citysname"].ToString();

            caruseway = (new RentCarBLL()).GetModel(Model.rentCarID).carusewayID;
            if (caruseway == 6)
            {
                var result = new BLL.HotLineBLL().GetModel(Convert.ToInt32(Model.targetCityID));
                endCityName = (new CityBLL()).GetFullResult(result.countyId).Rows[0]["citysname"].ToString();
            }
            else
            {
                endCityName = (new CityBLL()).GetFullResult(Model.targetCityID).Rows[0]["citysname"].ToString();
            }

            if (Model == null)
            {
                ShowError();
                return;
            }
        }

        private void ShowError()
        {
            Server.Transfer("/Error.aspx");
        }
    }
}