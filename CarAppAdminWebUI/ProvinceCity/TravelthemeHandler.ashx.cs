using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Common;
using Model;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// TravelthemeHandler 的摘要说明
    /// </summary>
    public class TravelthemeHandler : IHttpHandler
    {
        private readonly TravelthemeBll _travelthemeBll = new TravelthemeBll();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "plist":
                    PList(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
            }
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            var model = _travelthemeBll.GetModel(id);
            if (model == null)
            {
                message.IsSuccess = false;
                message.Message = "不存在此主题";
            }
            else if (model.Pid != 0)
            {
                _travelthemeBll.Delete(id);
            }
            else
            {
                var list = _travelthemeBll.GetList("pid=" + model.Id);
                if (list.Count > 0)
                {
                    message.IsSuccess = false;
                    message.Message = "此主题存在下级主题,不能进行删除操作";
                }
                else
                {
                    _travelthemeBll.Delete(id);
                }
            }
            message.IsSuccess = true;
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void PList(HttpContext context)
        {
            var list = _travelthemeBll.GetList("pid=0");
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            var model = new TravelTheme();
            PostHelper.GetModel<TravelTheme>(ref model, context.Request.Form);
            model.Pid = 0;
            if (_travelthemeBll.IsExist(model.Name))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此主题";
            }
            else
            {
                _travelthemeBll.Add(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            var model = _travelthemeBll.GetModel(id);
            PostHelper.GetModel<TravelTheme>(ref model, context.Request.Form);
            if (_travelthemeBll.IsExist(model.Name,id))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此主题";
            }
            else
            {
                _travelthemeBll.Update(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string where = "name like '%" + keyword + "%'";

            var list = _travelthemeBll.GetList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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