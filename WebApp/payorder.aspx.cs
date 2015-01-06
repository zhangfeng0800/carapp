using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp
{
    public partial class payorder : System.Web.UI.Page
    {
        public string order;
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
        public string balance;
        public UserAccount user = new UserAccount();
        public string Username { get; set; }
        public int IsLogined { get; set; }
        protected bool IsRedirect { get; set; }
        protected Model.UserAccount userAccount = new Model.UserAccount();
        protected override void OnInit(EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                IsLogined = 0;
                Username = "游客";
            }
            else
            {
                userAccount = Session["UserInfo"] as Model.UserAccount;
                IsLogined = 1;
                Username = userAccount.Compname;
            }
            base.OnInit(e);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分
                if (Session["UserInfo"] == null)
                {
                    Response.Redirect("/Login.aspx?returnVal=" + Request.Url);
                }
                user = (UserAccount)Session["UserInfo"];
                if (Request.Form.Count == 0)
                {
                    Response.Redirect("/default.aspx");
                }
                if (!IsPostBack)
                {
                    if (Request.Form.Count > 0)
                    {
                        string orderId = Request.Form[0].ToString();
                        Session["orderid"] = Request.Form[0].ToString();
                        order = orderId;
                        var orderbll = new BLL.OrderBLL();
                        var dt = orderbll.GetOrderInfo(orderId);
                        
                        useway = dt.Rows[0]["name"].ToString();
                        startplace = dt.Rows[0]["startAddress"].ToString();
                        endplace = dt.Rows[0]["arriveaddress"].ToString();
                        startDate = dt.Rows[0]["departuretime"].ToString();
                        if (startDate == "")
                        {
                            startDate = dt.Rows[0]["flightdate"].ToString();
                        }
                        if (startDate == "")
                        {
                            startDate = dt.Rows[0]["pickuptime"].ToString();
                        }
                        name = dt.Rows[0]["username"].ToString();
                        Tephone = dt.Rows[0]["telphone"].ToString();
                        //useTime = dt.Rows[0]["name"].ToString();
                        cartype = dt.Rows[0]["typename"].ToString();
                        startprice = dt.Rows[0]["ordermoney"].ToString();
                        kiloprice = dt.Rows[0]["kiloprice"].ToString();
                        hourprice = dt.Rows[0]["hourprice"].ToString();
                        passengernum = dt.Rows[0]["passengernum"].ToString();
                        feeincludes = dt.Rows[0]["feeincludes"].ToString();
                        passegername = dt.Rows[0]["passengername"].ToString();
                        //balance = dt.Rows[0]["balance"].ToString();
                        balance = new BLL.UserAccountBLL().GetMaster(user.Id).Balance.ToString();
                        orderpay.Value = orderId;

                        var data = (new CityBLL()).GetByRentId(dt.Rows[0]["rentcarid"].ToString());
                        if (data.Rows.Count > 0)
                        {
                            startplace = data.Rows[0]["provincename"].ToString() + data.Rows[0]["cityname"].ToString() +
                                         data.Rows[0]["townname"].ToString() + dt.Rows[0]["startAddress"].ToString();
                            endplace = dt.Rows[0]["arriveaddress"].ToString();
                        }
                        if (useway.Contains("热门"))
                        {
                            var hotlineid = int.Parse(dt.Rows[0]["hotlineid"].ToString());
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
                        Response.Write("<script>alert('请勿重新刷新页面');location='/'</script>");
                    }
                }
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }
    }
}