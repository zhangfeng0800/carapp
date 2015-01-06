using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI
{
    public partial class Logout : System.Web.UI.Page
    {
        readonly AdminBll _adminBll = new AdminBll();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var httpCookie = Request.Cookies["exten"];
                if (httpCookie != null)
                {
                    var exten = httpCookie.Value;
                    new ExtenLogBLL().Insert(new ExtenLog()
                    {
                        Exten = exten,
                        Name = User.Identity.Name,
                        OperationTime = DateTime.Now,
                        OperationType = CallcenterOperationType.签出.ToString()
                    });
                    if (exten != "0")
                    {
                        var parameters = new Dictionary<string, string>();
                        var bll = new AdminBll();

                        parameters.Add("groupid", "0");
                        parameters.Add("exten", exten);
                        parameters.Add("state", "0");
                        var result = GetServiceResponse("http://" + WebConfigurationManager.AppSettings["callcenteraddr"] + "/CheckInOut", parameters);
                        if (string.IsNullOrEmpty(result))
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('退出失败，请联系管理员')", true);
                            return;
                        }
                        var dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(result);
                        if (dictionary.First().Value == "failure")
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('退出失败，请联系管理员')", true);

                            return;
                        }
                        Global.RemoveExten(exten);
                        LogHelper.WriteOperation("客服[" + exten + "]签出，签出的坐席号是[" + exten + "]，签出时间是[" + DateTime.Now.ToString() + "]",OperationType.Login, "签出成功");
                    }
                }

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            System.Web.Security.FormsAuthentication.SignOut();
            var model = _adminBll.GetModel(User.Identity.Name);
            model.Status = 0;
            _adminBll.Update(model);
            Response.Redirect("Login.aspx");
        }
        private string GetServiceResponse(string url, Dictionary<string, string> parameters)
        {
            var suffix = new StringBuilder();
            foreach (var parameter in parameters)
            {
                suffix.Append(parameter.Key);
                suffix.Append("=");
                suffix.Append(parameter.Value);
                suffix.Append("&");
            }
            Stream stream = new MemoryStream();
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(url + "?" + suffix.ToString().TrimEnd('&'));
                WebResponse response = request.GetResponse();
                stream = response.GetResponseStream();
                if (stream != null)
                {
                    var reader = new StreamReader(stream);
                    return reader.ReadToEnd();
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            finally
            {
                if (stream != null)
                {
                    stream.Close();
                    stream.Dispose();
                }
            }
            return "";
        }
    }
}