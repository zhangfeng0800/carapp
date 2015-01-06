using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getCityByLetter 的摘要说明
    /// </summary>
    public class getCityByLetter : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["index"] != null)
            {

                int index;
                var condtion = "";
                if (!int.TryParse(context.Request.QueryString["index"], out index))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败,
                        Message = Message.BADPARAMETERS
                    }));
                    return;
                }
                if (index == 1)
                {
                    condtion = "('A','B','C','D','E','F')";

                }
                else if (index == 2)
                {
                    condtion = "('G','H','I','J','K','L')";
                }
                else if (index == 3)
                {
                    condtion = "('M','N','O','P','Q','R')";
                }
                else if (index == 4)
                {
                    condtion = "('S','T','W','X','Y','Z')";
                }
                var data = (new province_cityBLL()).GetTableByLetter(condtion);
                if (data.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = data,
                        StatusCode = StatusCode.请求成功
                    }));
                    return;
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败,
                        Message = Message.BADPARAMETERS
                    }));
                    return;
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    StatusCode = StatusCode.请求失败,
                    Message = Message.BADPARAMETERS
                }));
                return;
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