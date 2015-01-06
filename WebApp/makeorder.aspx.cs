using System;
using System.Collections.Generic;
using System.Data;
using System.EnterpriseServices.Internal;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;
using ContactPerson = BLL.ContactPerson;

namespace WebApp
{
    public partial class makeorder : System.Web.UI.Page
    {
        public RentCarExt model;
        public UserAccount Account;
        public int passnum = 4;
        public DateTime dt;
        public string cityfullname = "";
        public string cittype = "";
        public string username = "";
        public string telphone = "";
        public string ticketnum = "";
        public int realnum;
        public List<Model.ContactPerson> Persons = new List<Model.ContactPerson>();
        protected void Page_Load(object sender, EventArgs e)
        {
            dt = DateTime.Now;
            if (Session["UserInfo"] != null)
            {
                if (Request.QueryString["transdata"] != null)
                {

                    int rentcarid;
                    if (!int.TryParse(Request.QueryString["transdata"], out rentcarid))
                    {
                        Response.Redirect("/");
                    }
                    var bll = new RentCarBLL();
                    var lists = bll.GetRentInfoById(rentcarid);
                    if (lists == null)
                    {
                        Response.Redirect("/Default.aspx");
                    }
                    else
                    {
                        model = lists.First();
                    }
                    if (model == null)
                    {
                        Response.Redirect("/Default.aspx");
                    }
                    int cityid = model.countyId;
                    cittype = (new CityBLL()).GetCityType(cityid.ToString());
                    Account = (UserAccount)Session["UserInfo"];
                    username = Account.Username;
                    telphone = Account.Telphone;
                    var rentcar = bll.GetModel(rentcarid).carTypeID;
                    var firstOrDefault = (new CarTypeBLL()).GetList().FirstOrDefault(p => p.id == rentcar);
                    if (firstOrDefault != null)
                        passnum = firstOrDefault.passengerNum;
                    var data = (new CityBLL()).GetFullResult(model.countyId.ToString());
                    if (data.Rows.Count > 0)
                    {
                        cityfullname = data.Rows[0]["citysname"].ToString() + data.Rows[0]["townname"].ToString();
                    }
                    if (model.carusewayID == 6)
                    {
                        RentCarBLL rentbll = new RentCarBLL();
                        var rentdata = rentbll.GetCarDetail(int.Parse(Request.QueryString["transdata"]));
                        var citybll = new CityBLL();
                        var datafull = citybll.GetFullResult(rentdata.Rows[0]["countyid"].ToString());
                        cityfullname = "起点城市：" + datafull.Rows[0]["provincename"].ToString() + datafull.Rows[0]["citysname"].ToString() + datafull.Rows[0]["townname"].ToString();
                        var hotlineid = rentdata.Rows[0]["hotlineid"].ToString();
                        var hotdata = (new HotLineBLL()).GetHotlineById(int.Parse(hotlineid)).Rows[0][0].ToString();
                        var hotModel = (new HotLineBLL()).GetModel(int.Parse(hotlineid));
                        int num = 0;
                        if (int.TryParse(Request.QueryString["booknum"], out num))
                        {
                            model.DiscountPrice = model.DiscountPrice + hotModel.Price * num;
                            ticketnum = "（包含门票" + num.ToString() + "张）";
                            realnum = num;
                        }
                        var targetdata = citybll.GetFullResult(hotdata);
                        if (Request.QueryString["istravel"] != null)
                        {
                            cityfullname += "<br/>终&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点：" +
                                            targetdata.Rows[0]["provincename"].ToString() +
                                            targetdata.Rows[0]["citysname"].ToString() +
                                            targetdata.Rows[0]["townname"].ToString() + hotModel.name;
                        }
                        else
                        {
                            cityfullname += "<br/>终&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点：" +
                                         targetdata.Rows[0]["provincename"].ToString() +
                                         targetdata.Rows[0]["citysname"].ToString() +
                                         targetdata.Rows[0]["townname"].ToString();
                        }

                    }
                    Persons = (new BLL.ContactPerson()).GetList(Account.Id);
                }
            }
            else
            {
                Response.Redirect("/Login.aspx?returnVal=" + this.Request.Url);
            }


        }

        public string WriteHour()
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 24; i++)
            {
                sb.Append("<option value='" + i + "'>" + i + "</option>");
            }
            return sb.ToString();
        }

        public string WriteMinutes()
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 60; i += 5)
            {
                sb.Append("<option value='" + i + "'>" + i + "</option>");
            }
            return sb.ToString();
        }


    }
}