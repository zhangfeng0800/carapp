using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Weixin
{
    /// <summary>
    /// MenuHandler 的摘要说明
    /// </summary>
    public class MenuHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string id = context.Request["id"];
            if (string.IsNullOrEmpty(id))
            {
                id = "0";
            }
            List<WxMenu> list = new WxMenuBLL().GetList(Convert.ToInt32(id));

            if (id == "0")
                list.ForEach(a =>
                    {
                        a.state = "closed";
                    });
            else
                list.ForEach(a =>
                {
                    a.state = "open";
                });


            context.Response.Write(JsonConvert.SerializeObject(list));
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