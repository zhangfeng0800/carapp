using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// SaveCarUseWay 的摘要说明
    /// </summary>
    public class SaveCarUseWay : IHttpHandler
    {
        private readonly CarUseWayBLL _carUseWayBll = new CarUseWayBLL();
        public void ProcessRequest(HttpContext context)
        {
            var message = new AjaxResultMessage();
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            string name = context.Request["name"];
            string description = context.Request["description"];
            string imgUrl = context.Request["imgUrl"];
            int id = Convert.ToInt32(context.Request["id"]);
            if (_carUseWayBll.IsExist(id, name))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此服务方式";
            }
            else
            {
                _carUseWayBll.UpdateData(new Model.CarUseWay()
                {
                    Id = id, 
                    Name = name,
                    Description = description,
                    ImgUrl = imgUrl
                });
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
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