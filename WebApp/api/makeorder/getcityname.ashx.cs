using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getcityname 的摘要说明
    /// </summary>
    public class getcityname : IHttpHandler
    {
     
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["transdata"] != null)
            {
                int transdataid = 0;
                if (!int.TryParse(context.Request.QueryString["transdata"], out transdataid))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Message = Message.BADPARAMETERS,
                        StatusCode = StatusCode.请求失败
                    }));
                    return;
                }
                RentCarBLL bll = new RentCarBLL();
                var model = bll.GetModel(transdataid);
                var cityid = model.countyId;
                var data = (new CityBLL()).GetFullResult(cityid.ToString());

                if (data.Rows.Count > 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = new
                        {
                            provinceid = data.Rows[0]["provinceid"],
                            provincename = data.Rows[0]["provincename"],
                            cityid = data.Rows[0]["cityid"],
                            cityname = data.Rows[0]["citysname"],
                            townname = data.Rows[0]["townname"],
                            townid = data.Rows[0]["townid"]
                        },
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