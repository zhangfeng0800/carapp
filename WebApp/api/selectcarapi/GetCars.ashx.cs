using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.selectcarapi
{
    /// <summary>
    /// GetCars 的摘要说明
    /// </summary>
    public class GetCars : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString.Count == 4)
            {
                if (context.Request.QueryString["cityID"] != null && context.Request.QueryString["useType"] != null &&
                    context.Request.QueryString["hotlineId"] != null && context.Request.QueryString["linetype"] != null)
                {
                    var cityId = context.Request.QueryString["cityId"];
                    var usetype = context.Request.QueryString["useType"];
                    var hotlineId = context.Request.QueryString["hotlineId"];
                    var lineType = context.Request.QueryString["lineType"];
                    DataTable dt = new RentCarBLL().GetCarsInfoHot(cityId, hotlineId, Convert.ToInt32(usetype),lineType);
                    if (dt.Rows.Count > 0)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = dt,
                            Message = Message.SUCCESS,
                            StatusCode = StatusCode.请求成功
                        }));
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.BADPARAMETERS,
                        StatusCode = StatusCode.请求失败
                    }));
                }
            }
            else if (context.Request.QueryString.Count == 2)
            {
                if (context.Request.QueryString["cityid"] != null && context.Request.QueryString["usewayid"] != null)
                {
                    var dt = new RentCarBLL().GetCarsInfo(context.Request.QueryString["cityid"],
                        Convert.ToInt32(context.Request.QueryString["usewayid"]));
                    if (dt.Rows.Count > 0)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = dt,
                            Message = Message.SUCCESS,
                            StatusCode = StatusCode.请求成功
                        }));
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Data = null,
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = null,
                        Message = Message.BADPARAMETERS,
                        StatusCode = StatusCode.请求失败
                    }));
                }

            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    Data = null,
                    Message = Message.BADPARAMETERS,
                    StatusCode = StatusCode.请求失败
                }));
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