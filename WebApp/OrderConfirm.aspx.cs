using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using Model;
using Coupon = Model.Coupon;

namespace WebApp
{
    public partial class OrderConfirm : System.Web.UI.Page
    {
        public string useway;
        public string startplace;
        public string endplace;
        public string startDate;
        public string name;
        public string Tephone;
        public string useTime;
        public string cartype;
        public string startprice;
        public string kiloprice;
        public string hourprice;
        public string passengernum;
        public string feeincludes;
        public string passegername;
        public string accountType;
        public string orderid;
        public string pickuptime;
        public string airportname;
        public string usehour;
        public string userid;
        public string tickinfo;
        public string flightno = "";
        public InvoiceBLL invoice = new InvoiceBLL();
        public UserAccount ua = new UserAccount();
        public List<Model.Coupon> list = new List<Coupon>();
        protected List<ChargeDescription> listcharge;
        protected void Page_Load(object sender, EventArgs e)
        {
            listcharge = new BLL.ChargeDescriptionBll().GetList("");
            if (Session["UserInfo"] == null)
            {
                Response.Redirect("/Login.aspx?returnVal=" + Request.Url);
            }
            if (Request.QueryString["orderid"] != null)
            {

                ua = (UserAccount) Session["UserInfo"];
                userid = ua.Id.ToString();
                orderid = Request.QueryString["orderid"];
                DataTable dt = new OrderBLL().GetOrderInfo(orderid);
                if (dt.Rows.Count > 0)
                {
                    if (int.Parse(dt.Rows[0]["orderstatusid"].ToString()) == 5)
                    {
                        Response.Write("<script>alert('此订单已经取消');location='/pcenter/myorders.aspx'</script>");
                        return;
                    }
                    if (int.Parse(dt.Rows[0]["orderstatusid"].ToString()) > 1)
                    {
                        Response.Write("<script>alert('此订单已经付款');location='/pcenter/myorders.aspx'</script>");
                        return;
                    }
                    useway = dt.Rows[0]["name"].ToString();
                    startplace = dt.Rows[0]["startAddress"].ToString();
                    endplace = dt.Rows[0]["arriveaddress"].ToString();
                    startDate = dt.Rows[0]["departuretime"].ToString();
                    if (startDate == "")
                    {
                        startDate = dt.Rows[0]["flightdate"].ToString();
                    }
                    name = dt.Rows[0]["compname"].ToString();
                    //useTime = dt.Rows[0]["name"].ToString();
                    cartype = dt.Rows[0]["typename"].ToString();

                    startprice = Math.Round(double.Parse(dt.Rows[0]["ordermoney"].ToString()), 2).ToString();
                    kiloprice = Math.Round(double.Parse(dt.Rows[0]["kiloprice"].ToString()), 2).ToString();
                    hourprice = Math.Round(double.Parse(dt.Rows[0]["hourprice"].ToString()), 2).ToString();
                    passengernum = dt.Rows[0]["passengernum"].ToString();
                    feeincludes = dt.Rows[0]["feeincludes"].ToString();
                    passegername = dt.Rows[0]["passengername"].ToString();
                    Tephone = dt.Rows[0]["passengerPhone"].ToString();
                    accountType = GetUserTypeName(dt.Rows[0]["type"].ToString());
                    pickuptime = dt.Rows[0]["pickuptime"].ToString();
                    airportname = dt.Rows[0]["airportname"].ToString();
                    usehour = dt.Rows[0]["usehour"].ToString();
                    order.Value = orderid;
                    flightno = dt.Rows[0]["flightno"].ToString();
                    var rentcarid = dt.Rows[0]["rentcarid"].ToString();
                    var data = (new CityBLL()).GetByRentId(rentcarid);
                    var coupon = new BLL.Coupon();


                    if (data.Rows.Count > 0)
                    {
                        startplace = data.Rows[0]["provincename"].ToString() + data.Rows[0]["cityname"].ToString() +
                                     data.Rows[0]["townname"].ToString() + dt.Rows[0]["startAddress"].ToString();
                        BLL.RentCarBLL bll = new RentCarBLL();
                        var rentdata = bll.GetRentCarById(rentcarid);
                        var useid = rentdata.Rows[0]["carusewayid"].ToString();
                        if (useid == "6")
                        {

                            var istravel = 0;
                            var hotlineid = int.Parse(rentdata.Rows[0]["hotlineid"].ToString());
                            try
                            {
                                istravel = (new BLL.HotLineBLL()).GetModel(hotlineid).IsTravel;
                            }
                            catch
                            {
                                istravel = 0;
                            }
                            if (istravel == 1)
                            {
                                tickinfo = "（门票" + dt.Rows[0]["ticketnum"] + "张）";
                            }
                            var countyid = (new HotLineBLL()).GetHotlineById(hotlineid);
                            var datafull = (new CityBLL()).GetFullResult(countyid.Rows[0][0].ToString());
                            endplace = datafull.Rows[0]["provincename"].ToString() +
                                       datafull.Rows[0]["citysname"].ToString() +
                                       datafull.Rows[0]["townname"].ToString() + dt.Rows[0]["arriveaddress"].ToString();
                        }
                        else
                        {
                            var targetcity = dt.Rows[0]["targetcityid"].ToString();

                            var datafull = (new CityBLL()).GetFullResult(targetcity);
                            endplace = datafull.Rows[0]["provincename"].ToString() +
                                       datafull.Rows[0]["citysname"].ToString() +
                                       datafull.Rows[0]["townname"].ToString() + dt.Rows[0]["arriveaddress"].ToString();
                        }
                    }
                    else
                    {

                    }
                }
                else
                {
                    Response.Redirect("/Default.aspx"); 
                }
            }
            else
            {
                Response.Redirect("/Default.aspx");
            }

        }
        public string GetUserTypeName(string typeid)
        {
            if (typeid == "0")
            {
                return "集团管理员";
            }
            else if (typeid == "1")
            {
                return "部门经理";
            }
            else if (typeid == "2")
            {
                return "部门员工";
            }
            else
            {
                return "个人账户";
            }

        }

    }
}