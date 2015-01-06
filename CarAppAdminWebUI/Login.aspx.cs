using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI
{
    public partial class Login : System.Web.UI.Page
    {
        readonly AdminBll _adminBll = new AdminBll();
        private string url = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            url = WebConfigurationManager.AppSettings["callcenteraddr"];
        }
        public List<Extent> GetList()
        { 
            var response = ServiceHelper.GetServiceResponse("http://"+url+"/GetAllExten",
                new Dictionary<string, string>());
            var result = (ResponseResult)JsonConvert.DeserializeObject(response, typeof(ResponseResult));
            if (result == null)
            {
                return new List<Extent>();
            }
            var count = 0;
            var extentlist = (new ExtenLogBLL()).ExtentPager("", 1, 1000, 1, out count);
            var availableList= result.GetAllExtenResult.Where(p => p.Status == 0).ToList();
            return availableList.Where(extent => extentlist.Any(p => p.Exten.Trim() == extent.Exten.Trim())).ToList();
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            var httpCookie = Request.Cookies["VerifyCode"];
            if (httpCookie == null || txt_verifycode.Value.ToLower() != httpCookie.Value.ToLower())
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('验证码错误')", true);
                return;
            }
            if (service.Checked)
            {
                var dict = new Dictionary<string, string> { { "groupid", "0" }, { "exten", myselect.Value } };
                var result = ServiceHelper.GetServiceResponse("http://" + url + "/GetStatus", dict);
                if (result.Contains("checkedin"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('请选择其它坐席')", true);
                    return;
                }
            }
            string adminName = this.AdminName.Value;
            string adminPassword = Common.EncryptAndDecrypt.Encrypt(this.AdminPassword.Value);
            if (string.IsNullOrEmpty(adminName))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('用户名不能为空')", true);
                return;
            }
            if (string.IsNullOrEmpty(adminPassword))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('密码不能为空')", true);
                return;
            }
            var adminModel = _adminBll.GetModel(adminName);
            if (adminModel == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
                return;
            }
            var isLogin = _adminBll.IsLogin(adminName, adminPassword);
            if (service.Checked && isLogin == true && adminModel.AdminGroupsId == 2)
            {
                var parameters = new Dictionary<string, string>
                {
                    {"state", "1"},
                    {"groupid", "0"},
                    {"exten", myselect.Value}
                };
                var returnResult = ServiceHelper.GetServiceResponse("http://" + url + "/CheckInOut", parameters);
                if (string.IsNullOrEmpty(returnResult))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
                    return;
                }
                var dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(returnResult);
                switch (dictionary.First().Value)
                {
                    case "failure":
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
                        return;
                    case "success":
                        {
                            LogHelper.WriteOperation("客服[" + adminName + "]登录，登录的坐席号是[" + myselect.Value + "]，登录时间是[" + DateTime.Now.ToString() + "]", OperationType.Login, "登陆成功");
                            var extenlogbll = new ExtenLogBLL();
                            extenlogbll.Insert(new ExtenLog() { Exten = myselect.Value, Name = adminName, OperationTime = DateTime.Now, OperationType = CallcenterOperationType.签入.ToString() });
                            FormsAuthentication.SetAuthCookie(adminName, false);
                            Global.ExtenLogin(myselect.Value);
                            Response.Cookies.Add(new HttpCookie("exten", myselect.Value));
                            Response.Redirect("Default.aspx");
                        }
                        break;
                    default:
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
                        break;
                }
            }
            else if (admin.Checked && isLogin && adminModel.AdminGroupsId != 2)
            {
                FormsAuthentication.SetAuthCookie(adminName, false);
                Response.Cookies.Add(new HttpCookie("exten", "0"));
                LogHelper.WriteOperation("后台登录", OperationType.Login, "登录成功", adminName);
                Response.Redirect("Default.aspx");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
            }
            #region
            //if ((service.Checked && adminModel.AdminGroupsId == 2) || (admin.Checked && ((adminModel.AdminGroupsId == 1)) || (adminModel.AdminGroupsId == 3)))
            //{ bool isLogin = _adminBll.IsLogin(adminName, adminPassword);
            //   

            //if (service.Checked)
            //{
            //    var parameters = new Dictionary<string, string>();
            //    var response = ServiceHelper.GetServiceResponse("http://callcenter.iezu.cn:9003/GetAllExten", new Dictionary<string, string>());
            //    var result = ((ResponseResult)JsonConvert.DeserializeObject(response, typeof(ResponseResult)));
            //    if (result.GetAllExtenResult.Where(p=>p.Exten==myselect.Value).ToList().Count == 0)
            //    {
            //        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
            //        return;
            //    }
            //    parameters.Add("state", "1");
            //    parameters.Add("groupid", "0");
            //    parameters.Add("exten", myselect.Value);
            //    var returnResult =ServiceHelper.GetServiceResponse("http://callcenter.iezu.cn:9003/CheckInOut", parameters);
            //    if (string.IsNullOrEmpty(returnResult))
            //    {
            //        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
            //        return;
            //    }
            //    var dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(returnResult);
            //    if (dictionary.First().Value == "failure")
            //    {
            //        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
            //        return;
            //    }
            //}
            //if (isLogin)
            //{
            //    if (service.Checked)
            //    {
            //        LogHelper.WriteOperation("客服[" + adminName + "]登录，登录的坐席号是[" + myselect.Value + "]，登录时间是[" + DateTime.Now.ToString() +"]",OperationType.Login, "登陆成功");
            //        var extenlogbll = new ExtenLogBLL();
            //        extenlogbll.Insert(new ExtenLog() { Exten = myselect.Value, Name = adminName, OperationTime = DateTime.Now, OperationType = CallcenterOperationType.签入.ToString() });
            //        Global.ExtenLogin(myselect.Value);
            //    }
            //    else
            //    {
            //        LogHelper.WriteOperation("后台登录", OperationType.Login, "登录成功", adminName);
            //    }
            //    LogHelper.WriteOperation("客服[" + AdminName.Value + "]签入，签入的坐席号是[" + myselect.Value + "]，签入时间是[" + DateTime.Now.ToString() +"]", OperationType.Login, "签入成功");
            //    var model = _adminBll.GetModel(adminName);
            //    model.Status = 1;
            //    _adminBll.Update(model);
            //    FormsAuthentication.SetAuthCookie(adminName, false);
            //    Response.Cookies.Add(service.Checked? new HttpCookie("exten", myselect.Value): new HttpCookie("exten", "0"));
            //    Response.Redirect("Default.aspx");
            //}
            //else
            //{
            //    LogHelper.WriteOperation("后台登录", OperationType.Login, "登录失败", adminName);
            //    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('用户名或密码输入错误，请重新输入')", true);
            //    return;
            //}
            //}
            //else
            //{
            //    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('登录失败')", true);
            //    return;
            //}
            #endregion

        }


    }

    public class ResponseResult
    {
        public List<Extent> GetAllExtenResult { get; set; }
        public string ExecResult { get; set; }
    }
    public class Extent
    {
        public string Exten { get; set; }
        public int GroupId { get; set; }
        public int Status { get; set; }
    }
}