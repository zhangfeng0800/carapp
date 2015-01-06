using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class MyAddressManager : PageBase.PageBase
    {
        protected string Method = "添加常用地址";
        protected string FormMethod = "save";
        protected int updateID = 0;
        protected Model.userAddressExt userAddress = new Model.userAddressExt();
        public string provinceID = "";
        public string cityID = "";
        public string townID = "";
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request["id"]))
            {
                int id = Common.Tool.GetInt(Request["id"]);
                Method = "修改常用地址";
                FormMethod = "upDate";
                userAddress = new BLL.UserAddressBLL().GetAddressById(id).FirstOrDefault();
                if (userAddress == null)
                    Response.Redirect("MyAddress.aspx");
                updateID = id;

                provinceID = userAddress.cityID.Substring(0, 2);
                cityID = userAddress.cityID.Substring(0, 4);
                townID = userAddress.cityID;
            }
            else
            {
                if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["event"] == "save")
                {
                    Model.userAddress address = GetAddress();
                    if (address == null)
                    {
                        return;
                    }
                    new BLL.UserAddressBLL().AddData(address);
                    Response.Redirect("MyAddress.aspx");
                }
                if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["event"] == "upDate")
                {
                    Model.userAddress address = GetAddress();
                    if (address == null)
                    {
                        return;
                    }
                    new BLL.UserAddressBLL().UpdateData(address);
                    Response.Redirect("MyAddress.aspx");
                }
            }
        }

        protected Model.userAddress GetAddress()
        {
            Model.userAddress userAdd = new Model.userAddress();
            userAdd.cityID = Request.Form["town"];
            userAdd.address = Request.Form["address"];
            userAdd.remarks = Request.Form["remark"];
            userAdd.userID = userAccount.Id;
            userAdd.location = Request.Form["location"];
            if (Request.Form["sort"].ToString() == "")
                userAdd.sort = 0;
            else
                userAdd.sort =Convert.ToInt32(Request.Form["sort"]);
            
            if (Request.Form["location"] == null || Request.Form["location"] == "")
            {
                              return null;
            }
            userAdd.provinceID = new BLL.province_cityBLL().GetProvenceID(userAdd.cityID);
            if (!string.IsNullOrEmpty(Request.Form["updateid"]))
            {
                userAdd.id = Convert.ToInt32(Request.Form["updateid"]);
            }
            return userAdd;
        }
    }
}