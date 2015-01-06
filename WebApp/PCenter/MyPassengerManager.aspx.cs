using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class MyPassengerManager : PageBase.PageBase
    {
        protected string Method = "添加常用乘车人";
        protected string FormMethod = "save";
        protected int updateID = 0;
        protected Model.ContactPerson passenger = new Model.ContactPerson();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request["id"]))
            {
                int id = Common.Tool.GetInt(Request["id"]);
                Method = "修改乘车人";
                passenger = new BLL.ContactPerson().GetList(userAccount.Id).Where(s => s.Id == id).FirstOrDefault();
                if (passenger == null)
                    Response.Redirect("MyPassenger.aspx");
                FormMethod = "upDate";
                updateID = id;
            }
            else
            {
                if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["event"] == "save")
                {
                    Model.ContactPerson address = GetPassengerData();
                    new BLL.ContactPerson().Add(address);
                    Response.Redirect("MyPassenger.aspx");
                }
                if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["event"] == "upDate")
                {
                    Model.ContactPerson passenger2 = GetPassengerData();
                    passenger = new BLL.ContactPerson().GetList(userAccount.Id).Where(s => s.Id == passenger2.Id).FirstOrDefault();

                    if (passenger.TelePhone != passenger2.TelePhone && new BLL.ContactPerson().GetOneByPhone(passenger2.TelePhone,passenger2.UserId.ToString()).Id == 0)
                    {
                        new BLL.ContactPerson().Update(passenger2); //如果修改手机号码，且新号码不存在，则添加
                    }
                    else if (passenger.TelePhone == passenger2.TelePhone)
                    {
                        new BLL.ContactPerson().Update(passenger2);//未修改手机号码，只修改姓名，则直接修改
                    }
                    Response.Redirect("MyPassenger.aspx");
                }
            }
        }

        protected Model.ContactPerson GetPassengerData()
        {
            Model.ContactPerson passenger = new Model.ContactPerson();
            passenger.ContactName = Request.Form["passengerName"];
            passenger.TelePhone = Request.Form["telePhone"];
            passenger.UserId = userAccount.Id;
            if (!string.IsNullOrEmpty(Request.Form["updateid"]))
            {
                passenger.Id = Convert.ToInt32(Request.Form["updateid"]);
            }
            return passenger;
        }
    }
}