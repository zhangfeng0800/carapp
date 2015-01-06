using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using DAL;
using BLL;
using System.Data;
using System.Data.SqlClient;
using Model;
namespace WebApp.api
{
    /// <summary>
    /// UserAddress 的摘要说明
    /// </summary>
    public class UserAddress : IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            UserAddressBLL objBll = new UserAddressBLL();
            ProvinceBLL objProvince=new ProvinceBLL ();
            province_cityBLL objCity = new province_cityBLL();
            if (context.Request.Params["getAddress"] != null)
            {
                int userID = Convert.ToInt32(context.Session["userid"]);
                List<userAddressExt> objList = objBll.GetAddressList(userID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string addressList = jss.Serialize(objList);
                context.Response.Write(addressList);
            }
            if (context.Request.Params["type"]== "delete")
            {
                int id = Convert.ToInt32(context.Request.Params["deleteID"]);
                if (objBll.DeleteById(id) == 1)
                {
                    context.Response.Write("delete_success");
                    context.Response.End();
                }
            }
            if (context.Request.Params["type"] == "edit")
            {
                int id = Convert.ToInt32(context.Request.Params["addressID"]);
                List<userAddressExt> objList=objBll.GetAddressById(id);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string addressList = jss.Serialize(objList);
                context.Response.Write(addressList);
            }
            if (context.Request.Params["type"] == "select")
            {
                List<province> objList = objProvince.GetProvince();
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string provinceList = jss.Serialize(objList);
                context.Response.Write(provinceList);
            }
            //查询全部城市
            if (context.Request.Params["getCity"] == "myCity")
            {
                List<province_city> objList = objCity.GetCity();
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string cityList = jss.Serialize(objList);
                context.Response.Write(cityList);
            }
            //根据省份查询城市
            if (context.Request.Params["selectByID"] != null)
            {
                int provinceID = Convert.ToInt32(context.Request.Params["provinceID"]);
                List<province_city> objList = objCity.GetCityById(provinceID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string cityList = jss.Serialize(objList);
                context.Response.Write(cityList);
            }
            //保存用户更新的地址
            if (context.Request.Params["add"] != null)
            {
                string provinceID = context.Request.Params["addProvince"].ToString();
                string cityID = context.Request.Params["addCity"].ToString();
                string address = context.Request.Params["addAddress"].ToString();
                string remarks=context.Request.Params["addRemark"].ToString();
                int id =Convert.ToInt32(context.Request.Params["id"]);
                int n = objBll.UpdateData(new userAddress
                {
                    provinceID=provinceID,
                    cityID = cityID,
                    address = address,
                    remarks = remarks,
                    id = id
                });
                if (n != 0)
                    context.Response.Write("success");
            }
            //保存用户新增地址
            if (context.Request.Params["add_address"] != null)
            {
                string provinceID = context.Request.Params["provinceID"].ToString();
                string cityID = context.Request.Params["cityID"].ToString();
                string address = context.Request.Params["address"].ToString();
                string remarks = context.Request.Params["remarks"].ToString();
                int userID = Convert.ToInt32(context.Session["userid"]);
                object n = objBll.AddData(new userAddress
                {
                    provinceID = provinceID,
                    cityID = cityID,
                    address = address,
                    remarks = remarks,
                    userID=userID
                });
                if (n !=null)
                {
                    context.Response.Write(n.ToString());
                    context.Response.End();
                }
            }
            if (context.Request.Params["Validate"] != null)
            {
                context.Session["username"] = "王丽梅";
                context.Session["userid"] = "2";
                if (context.Session["username"] != null)
                {
                    context.Response.Write(context.Session["username"].ToString());
                }
                else
                {
                    context.Response.Write("NotLogin");
                }
            }
            if (context.Request.Params["Logout"] != null)
            {
                context.Session.Clear();
                context.Session.Abandon();
                context.Response.Write("out");
                context.Response.End();
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}