using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// gethotlineCityName 的摘要说明
    /// </summary>
    public class gethotlineCityName : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["transdata"] != null)
            {
                int rentid = 0;
                if (!int.TryParse(context.Request.QueryString["transdata"], out rentid))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        StatusCode = StatusCode.请求失败
                    }));
                    return;
                }
                else
                {
                    var bll = new BLL.RentCarBLL();
                    var data = bll.GetCityName(rentid.ToString());
                    if (data.Rows.Count > 0)
                    {
                        AjaxResponse response=null;
                        if (context.Request.QueryString["townid"] != null)
                        {
                            response = new AjaxResponse
                            {
                                Data = new
                                {
                                    townname = data.Rows[0]["startcity"],
                                    cityname =data.Rows[0]["startcity"] ,
                                    startid = data.Rows[0]["startid"],
                                    endid =context.Request.QueryString["townid"],
                                    provinceid = data.Rows[0]["provenceId"],
                                    provincename = data.Rows[0]["provincename"],
                                    cityid = data.Rows[0]["cityid"],
                                    startcityname = data.Rows[0]["cityname"],
                                    targetprovince = data.Rows[0]["provincename"],
                                    targetcity = data.Rows[0]["cityname"]
                                },
                                Message = Message.SUCCESS,
                                StatusCode = StatusCode.请求成功
                            };
                        }
                        else
                        {
                            response = new AjaxResponse
                            {
                                Data = new
                                {
                                    townname = data.Rows[0]["startcity"],
                                    cityname = data.Rows[0]["targetcity"],
                                    startid = data.Rows[0]["startid"],
                                    endid = data.Rows[0]["endid"],
                                    provinceid = data.Rows[0]["provenceId"],
                                    provincename = data.Rows[0]["provincename"],
                                    cityid = data.Rows[0]["cityid"],
                                    startcityname = data.Rows[0]["cityname"],
                                    targetprovince = data.Rows[0]["targetprovince"],
                                    targetcity = data.Rows[0]["targetcitys"]
                                },
                                Message = Message.SUCCESS,
                                StatusCode = StatusCode.请求成功
                            };
                        }

                        context.Response.Write(JsonConvert.SerializeObject(response ));
                        return;
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                        {
                            Message = Message.EMPTY,
                            StatusCode = StatusCode.请求失败
                        }));
                    }

                    return;
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    StatusCode = StatusCode.请求失败
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