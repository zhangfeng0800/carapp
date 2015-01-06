using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// getpassenger 的摘要说明
    /// </summary>
    public class getpassenger : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "filter")
            {
                if (context.Request["telphone"] != null)
                {
                    var usermodel = (new UserAccountBLL()).GetModel(context.Request["telphone"]);
                    if (usermodel == null)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                        return;
                    }
                    var contactList = new BLL.ContactPerson().GetList(usermodel.Id).Where(p => p.ContactName.Contains(context.Request["contactName"])).ToList();
                    context.Response.Write(contactList.Count == 0
                        ? JsonConvert.SerializeObject(new {resultcode = 0})
                        : JsonConvert.SerializeObject(
                            new
                            {
                                resultcode = 1,
                                data = contactList
                            }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
                }
            }
            else if(context.Request["action"]=="list")
            {
                if (context.Request["telphone"] != null)
                {
                    var usermodel = (new UserAccountBLL()).GetModel(context.Request["telphone"]);
                    if (usermodel == null)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                        return;
                    }
                    var contactList = new BLL.ContactPerson().GetList(usermodel.Id);
                    if (contactList.Count == 0)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = contactList }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
                }
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