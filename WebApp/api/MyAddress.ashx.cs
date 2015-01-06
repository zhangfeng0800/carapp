using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// MyAddress 的摘要说明
    /// </summary>
    public class MyAddress : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(context, action);
        }
        public void Routing(HttpContext context, string action)
        {
            switch (action)
            {
                case "add": Add(context); break;
                case "update": Update(context); break;
                case "Delete": Delete(context); break;
                default:
                    break;
                case "List":
                    List(context);break;
            }
        }

        private void List(HttpContext context)
        {
            if (context.Session["UserInfo"] == null) return;
            var user = (UserAccount) context.Session["UserInfo"];
            if (user == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new {resultcode = 0, msg = "请求失败"}));
                return;
            }
            var uid = user.Id;
            int pageIndex = 1;
            int pageSize = 10;
            if (context.Request["pageIndex"] != null)
            {
                pageIndex = Convert.ToInt32(context.Request["pageIndex"]);
            }
            int count = 0;

            var address = new BLL.UserAddressBLL().GetPageList(pageIndex, pageSize, " userID=" + uid, out count);
            address.ForEach(c=>
                                {
                                    c.provinceID = new BLL.CityBLL().GetFullAddressByCodeID(c.cityID);
                                });

            context.Response.Write(
                JsonConvert.SerializeObject(new {resultcode = 1, list = address, pageCount = Math.Ceiling(count / (decimal)pageSize) }));
        }

        public void Add(HttpContext context)
        { 
            
        }
        public void Update(HttpContext context)
        { 
            
        }
        public void Delete(HttpContext context)
        {
            string requestString = context.Request["ids"];
            requestString = requestString.Substring(0, requestString.Length - 1);
            string[] ids = requestString.Split(',');
            int[] IDS = new int[ids.Length];
            for (int i = 0; i < ids.Length; i++)
            {
                IDS[i] = Convert.ToInt32(ids[i]);
            }
            foreach (var item in IDS)
            {
                 new BLL.UserAddressBLL().DeleteById(item);
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