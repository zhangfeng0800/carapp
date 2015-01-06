using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common;
using Newtonsoft.Json;
using System.Web.SessionState;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// TransHandler 的摘要说明
    /// </summary>
    public class TransHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string action = context.Request["action"];
            
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = Message.NOTLOGIN, StatusCode = StatusCode.请求失败 }));
                return;
            }
            var user = context.Session["UserInfo"] as Model.UserAccount;
            var result = new AjaxResponse();
            try
            {
                var ubll = new BLL.UserAccountBLL();
                if (action == "usertransmoney")
                {
                    var toUser = ubll.GetModel(context.Request["telphone"]);
                    if (toUser != null)
                    {
                        result.StatusCode = StatusCode.请求成功;
                        string comname = "*" + toUser.Compname.Substring(1);
                        result.Data = comname;

                    }
                    else
                    {
                        result.StatusCode = StatusCode.用户名不存在;
                        result.Message = "用户不存在";
                    }
                }
                else if (action == "transmoney")
                {
                    if (Common.EncryptAndDecrypt.Encrypt(context.Request["paypwd"]) == user.PayPassword)
                    {
                        new BLL.AccountBLL().TransMoney(user.Id, context.Request["telphone"], Convert.ToDecimal(context.Request["money"]), "", "用户");
                        result.StatusCode = StatusCode.请求成功;
                    }
                    else
                    {
                        result.StatusCode = StatusCode.用户名不存在;
                        result.Message = "支付密码不正确";
                    }
                }
                else if (action == "getTransData")
                {
                    int id = Int32.Parse(context.Request["id"]);
                    var data = new BLL.AccountBLL().GetTransData(id);
                    if (data.Rows.Count > 0)
                    {
                        if (user.Id.ToString() == data.Rows[0]["fromUser"].ToString() || user.Id.ToString() == data.Rows[0]["toUser"].ToString())
                        {
                            var model = new
                            {
                                fromTel = data.Rows[0]["fromTel"],
                                fromName = data.Rows[0]["fromName"],
                                toTel = data.Rows[0]["toTel"],
                                toName = data.Rows[0]["toName"],
                                money = data.Rows[0]["money"],
                                createTime = data.Rows[0]["createTime"],
                                oprator = data.Rows[0]["oprator"].ToString() == "用户" ? data.Rows[0]["fromName"] : "管理员:" + data.Rows[0]["oprator"],
                            };
                            result.StatusCode = StatusCode.请求成功;
                            result.Data = model;
                        }
                        else
                        {
                            result.StatusCode = StatusCode.请求失败;
                            result.Message = "您无权查看这条信息";
                        }
                        
                    }
                    else
                    {
                        result.StatusCode = StatusCode.请求失败;
                        result.Message = "无效转账记录";
                    }

                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            catch (Exception exp)
            {
                IEZU.Log.LogHelper.WriteException(exp);
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { Data = null, Message = exp.Message, StatusCode = StatusCode.请求失败 }));
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