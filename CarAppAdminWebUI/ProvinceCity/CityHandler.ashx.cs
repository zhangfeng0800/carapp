using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// CityHandler 的摘要说明
    /// </summary>
    public class CityHandler : IHttpHandler
    {
        private readonly CityBLL _cityBll = new CityBLL();
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
                case "delete":
                    Delete(context);
                    break;
            }
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string idStr = context.Request["id"];
            int id;

            if (!int.TryParse(idStr, out id))
            {
                message.IsSuccess = false;
                message.Message = "城市编码无效";
            }
            else if (_cityBll.IsExistPid(idStr))
            {
                message.IsSuccess = false;
                message.Message = "此城市存在下级城市，不能进行删除";
            }
            else
            {
                _cityBll.Delete(id);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string parentidstr = context.Request["parentid"];
            string cityName = context.Request["cityName"];
            string codeidstr = context.Request["codeid"];
            string sort = context.Request["sort"];
            int parentid;
            int codeid;
            if (!int.TryParse(parentidstr, out parentid))
            {
                message.IsSuccess = false;
                message.Message = "请输入有效的上级城市编码";
            }
            else if(!int.TryParse(codeidstr,out codeid))
            {
                message.IsSuccess = false;
                message.Message = "请输入有效的城市编码";
            }
            else if (parentid!=0 && !_cityBll.IsExistCodeId(parentidstr))
            {
                message.IsSuccess = false;
                message.Message = "你输入的上级城市不存在";
            }
            else if (_cityBll.IsExistCodeId(codeidstr))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此城市编码";
            }
            else
            {
                var model = new Model.CityModel()
                {
                    CodeId = codeidstr,
                    ParentId = parentidstr,
                    CityName = cityName,
                    Sort=int.Parse(sort)
                };
                _cityBll.InsertCity(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string parentidstr = context.Request["parentid"];
            string cityName = context.Request["cityName"];
            string codeidstr = context.Request["codeid"];
            string id = context.Request["id"];
            string sort = context.Request["sort"];
            int parentid;
            int codeid;
            if (!int.TryParse(parentidstr, out parentid))
            {
                message.IsSuccess = false;
                message.Message = "请输入有效的上级城市编码";
            }
            else if (!int.TryParse(codeidstr, out codeid))
            {
                message.IsSuccess = false;
                message.Message = "请输入有效的城市编码";
            }
            else if (parentid != 0 && !_cityBll.IsExistCodeId(parentidstr))
            {
                message.IsSuccess = false;
                message.Message = "你输入的上级城市不存在";
            }
            else if (_cityBll.IsExistCodeId(codeidstr,id))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此城市编码";
            }
            else
            {
                var model = new Model.CityModel()
                {
                    CodeId = codeidstr,
                    ParentId = parentidstr,
                    CityName = cityName,
                    Sort=int.Parse(sort)
                };
                _cityBll.Update(model,id);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            string id = context.Request["id"];
            string keyword = context.Request["keyword"];
            
            if (string.IsNullOrEmpty(id))
            {
                id = "0";
            }
            string where = " parentid=" + id;
            string pwhere = " 1=1 ";
            if (string.IsNullOrEmpty(keyword))
            {
                pwhere += " and parentid=" + id;
            }

            if (!string.IsNullOrEmpty(keyword))
            {
                pwhere += " and cityName like '%" + Common.Tool.SqlFilter(keyword) + "%'";
            }


            List<CityModelExt> list;
            switch (id.Length)
            {
                case 1:
                    list = _cityBll.GetList(pwhere, "closed");
                    context.Response.Write(JsonConvert.SerializeObject(list));
                    break;
                case 2:
                    list = _cityBll.GetList(where, "closed");
                    context.Response.Write(JsonConvert.SerializeObject(list));
                    break;
                case 4:
                    list = _cityBll.GetList(where, "open");
                    context.Response.Write(JsonConvert.SerializeObject(list));
                    break;
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