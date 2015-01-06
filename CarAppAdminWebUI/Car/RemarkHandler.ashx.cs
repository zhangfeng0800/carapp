using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;
using NPOI.POIFS.Storage;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// RemarkHandler 的摘要说明
    /// </summary>
    public class RemarkHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "list")
            {
                List(context);
            }
            else if (context.Request["action"] == "add")
            {
                Add(context);
            }
            else if (context.Request["action"] == "edit")
            {
               Edit(context);
            }
        }

        public void List(HttpContext context)
        {
            context.Response.Write(JsonConvert.SerializeObject((new CarRemarkBLL()).GetDataTable()));

        }
        public void Add(HttpContext context)
        {
            try
            {
                var content = context.Request["content"];
                var sort = context.Request["sort"];
                var model = new CarRemark()
                {
                    Content = content,
                    CreateTime = DateTime.Now,
                    SortOrder = int.Parse(sort)
                };
                if (content.Length > 100)
                {
                    context.Response.Write( JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 ,Message="备注信息最大长度100"}));
                    return;
                }
                context.Response.Write((new CarRemarkBLL()).Insert(model) > 0
                    ? JsonConvert.SerializeObject(new { resultcode = ResultCode.成功 })
                    : JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败,Message="操作失败" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败, Message="未知错误" }));

            }
        }

        public void Edit(HttpContext context)
        {
            try
            {
                var content = context.Request["content"];
                var sort = context.Request["sort"];
                var id = int.Parse(context.Request["id"]);
                var model = new CarRemark()
                {
                    Content = content,
                    CreateTime = DateTime.Now,
                    SortOrder = int.Parse(sort),
                    Id =id
                };
                if (content.Length > 100)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败, Message = "备注信息最大长度100" }));
                    return;
                }
                context.Response.Write((new CarRemarkBLL()).Update(model) > 0
                    ? JsonConvert.SerializeObject(new { resultcode = ResultCode.成功 })
                    : JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败,Message="添加失败" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));

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