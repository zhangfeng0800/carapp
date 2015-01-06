using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.makeorder
{
    /// <summary>
    /// getairportbycityid 的摘要说明
    /// </summary>
    public class getairportbycityid : IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Session["UserInfo"] != null)
            {
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
                    OrderBLL orderBll = new OrderBLL();
                    DataTable dt = orderBll.GetTable(model.countyId.ToString());
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
                        return;
                    }

                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                {
                    Message = Message.NOTLOGIN,
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