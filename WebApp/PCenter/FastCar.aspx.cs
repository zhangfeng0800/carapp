using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public class cityFullByCodeID
    {
        public Model.CityModel privoce { get; set; }
        public Model.CityModel city { get; set; }
        public Model.CityModel country { get; set; }
        public cityFullByCodeID(string countryCodeID)
        {
            var bll = new BLL.CityBLL();
            country = bll.GetModule(countryCodeID);
            city = bll.GetModule(country.ParentId);
            privoce = bll.GetModule(city.ParentId);
        }
        public cityFullByCodeID()
        {
            country = new Model.CityModel();
            city = new Model.CityModel();
            privoce = new Model.CityModel();
        }
    }
    public partial class FastCar : PageBase.PageBase
    {
        protected List<Model.ContactPerson> passangerList;

        protected Model.QuickOrderCar updateQuickOrderCar = new Model.QuickOrderCar();
        protected cityFullByCodeID upCityFull = new cityFullByCodeID();
        protected cityFullByCodeID downCityFull = new cityFullByCodeID();
        protected List<BLL.BLLExpand.CarFullType> carFullTypes = new List<BLL.BLLExpand.CarFullType>();
        public string firstPassangerPhone = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            int userid = userAccount.Id;
            passangerList = new BLL.ContactPerson().GetList(userid);
            List<Model.ContactPerson> newPassangerList = new List<Model.ContactPerson>();
            newPassangerList.Add(new Model.ContactPerson() { ContactName = userAccount.Compname, TelePhone = userAccount.Telphone });
            foreach (var item in passangerList)
            {
                newPassangerList.Add(item);
            }
            passangerList = newPassangerList;
            if (Request.Form.Count > 1)
            {
                saveQuickOrderCar();
            }
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                updateQuickOrderCar = new BLL.QuickOrderCarBLL().GetModel(int.Parse(Request.QueryString["id"]));
                upCityFull = new cityFullByCodeID(updateQuickOrderCar.startCountryID);
                downCityFull = new cityFullByCodeID(updateQuickOrderCar.arriveCountryID);
                var result = new BLL.RentCarBLL().GetList(updateQuickOrderCar.carUseWayID, int.Parse(updateQuickOrderCar.startCountryID));
                foreach (var item in result)
                {
                    carFullTypes.Add(new BLL.BLLExpand.CarFullType(item));
                }
            }
            else
            {
                firstPassangerPhone = userAccount.Telphone;
            }
        }
        protected void saveQuickOrderCar()
        {
            Model.QuickOrderCar quickOrderCar = new Model.QuickOrderCar();
            bool isUpdate = false;
            if (!string.IsNullOrEmpty(Request.Form["orderCarID"]))
            {
                isUpdate = true;
                quickOrderCar = new BLL.QuickOrderCarBLL().GetModel(int.Parse(Request.Form["orderCarID"]));
                quickOrderCar.ID = int.Parse(Request.Form["orderCarID"]);
            }
            quickOrderCar.name = Request.Form["name"];
            quickOrderCar.carUseWayID = int.Parse(Request.Form["caruseway"]);
            quickOrderCar.startCountryID = Request.Form["upCountry"];
            quickOrderCar.upAddress = Request.Form["upAddress"];
            quickOrderCar.upAddressDetail = Request.Form["upAddress_Detail"];
            quickOrderCar.upPosition = Request.Form["upAddress_position"];
            quickOrderCar.arriveCountryID = Request.Form["downCountry"];
            quickOrderCar.downAddress = Request.Form["downAddress"];
            quickOrderCar.downAddressDetail = Request.Form["downAddress_Detail"];
            quickOrderCar.downPosition = Request.Form["downAddress_Position"];
            quickOrderCar.rentCarID = int.Parse(Request.Form["selectCars"]);
            quickOrderCar.passangerName = Request.Form["passangers"];
            quickOrderCar.passangerPhone = Request.Form["passangerTel"];
            quickOrderCar.userID = userAccount.Id;
            if (isUpdate)
            {
                new BLL.QuickOrderCarBLL().Update(quickOrderCar);
                Response.Write("<script>alert('修改成功!');window.location.href='/pcenter/fastcarlist.aspx'</script>");
                Response.End();
            }
            else
            {
                new BLL.QuickOrderCarBLL().Add(quickOrderCar);
                Response.Write("<script>alert('添加成功!');window.location.href='/pcenter/fastcarlist.aspx'</script>");
                Response.End();
            }

        }
    }
}