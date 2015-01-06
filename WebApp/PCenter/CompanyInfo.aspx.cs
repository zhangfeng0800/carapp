using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp.PCenter
{
    public partial class CompanyInfo : PageBase.PageBase
    {
        //protected List<Model.province> ProvList = new List<Model.province>();
        protected Model.CompanyInfo Ci = new Model.CompanyInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
            PersonCenter pCenter = (PersonCenter)this.Master;//判断是否有访问该页面的权限
            pCenter.redirectMaster = userAccount.Popedom.CompanyInfoPage;//权限
            switch (Request.Form["Action"])
            {
                case "SubmitCompanyInfo":
                    SubmitCompanyInfo();
                    break;
                default:
                    break;
            }
            BLL.CityBLL CB = new CityBLL();
            BLL.CompanyInfoBLL CIB = new CompanyInfoBLL();
            Ci = CIB.GetModelByUid(userAccount.Id);
            if (Ci == null)
            {
                Ci = new Model.CompanyInfo();
                Ci.Uid = userAccount.Id;
                Ci.Trade = 0;
                Ci.ProvinceId = "0";
                Ci.CityId = "0";
                Ci.DistrictId = "0";
                Ci.Kind = 0;
                CIB.Add(Ci);
            }
        }

        protected void SubmitCompanyInfo()//提交集团信息
        {
            string messageStr = "";
            try
            {
                BLL.CompanyInfoBLL CIB = new CompanyInfoBLL();
                Ci = CIB.GetModelByUid(userAccount.Id);
                Ci.Trade = Convert.ToInt32(Request.Form["Trade"]);
                Ci.ProvinceId = Common.Tool.GetString(Request.Form["ProvinceId"]);
                Ci.CityId = Common.Tool.GetString(Request.Form["CityId"]);
                Ci.DistrictId = Common.Tool.GetString(Request.Form["DistrictId"]);
                Ci.Kind = Convert.ToInt32(Request.Form["Kind"]);
                CIB.Update(Ci);

                BLL.UserAccountBLL UAB = new UserAccountBLL();
                Model.UserAccount User = UAB.GetModel(userAccount.Id);
                User.Tel = Request.Form["Tel"];
                UAB.UpdateData(User);
                User.Password = "";
                Session["UserInfo"] = User;
                messageStr = "Complete";
            }
            catch (Exception ex)
            {
                messageStr = ex.ToString();
            }
            Response.ContentType = "application/json";
            Response.Write("{\"Message\":\"" + messageStr + "\"}");
            Response.End();
        }
    }
}