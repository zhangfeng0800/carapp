using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// UserHobbyHandler 的摘要说明
    /// </summary>
    public class UserHobbyHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "DeleteHobby":
                    Delete(context);
                    break;
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
            }
        }

        private void Add(HttpContext context)
        {
            string Name = context.Request["Name"].ToString();
            int sort = Convert.ToInt32(context.Request["Sort"]);
            string image = context.Request["Image"];
            Model.UserHobby hobby = new UserHobby()
                                        {
                                            Name =  Name,
                                            Image = System.Web.Configuration.WebConfigurationManager.AppSettings["backUrl"]+image,
                                            Sort =  sort
                                        };
            int result =  new BLL.UserHobbyBll().AddData(hobby);
            context.Response.Write(JsonConvert.SerializeObject(new {IsSuccess = result}));
        }

        private void List(HttpContext context)
        {
            var list = new BLL.UserHobbyBll().GetListAll();
            context.Response.Write(JsonConvert.SerializeObject(new { rows = list }));
        }

        public  void Delete(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            int result =  new BLL.UserHobbyBll().DeleteData(id);
            context.Response.Write(result);
        }
        public  void Edit(HttpContext context)
        {
            var id = Convert.ToInt32(context.Request["Id"]);
            Model.UserHobby hobby = new BLL.UserHobbyBll().GetModel(id);
            hobby.Name = context.Request["Name"];
            hobby.Image = System.Web.Configuration.WebConfigurationManager.AppSettings["backUrl"] + context.Request["Image"];
            hobby.Sort = Convert.ToInt32(context.Request["Sort"]);

            var result= new BLL.UserHobbyBll().UpdateData(hobby);
            context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = result }));
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