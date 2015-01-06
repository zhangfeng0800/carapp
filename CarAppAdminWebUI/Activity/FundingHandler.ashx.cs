using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Activity
{
    /// <summary>
    /// FundingHandler 的摘要说明
    /// </summary>
    public class FundingHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "ruleslist":
                    GetRulesList(context);
                    break;
                case "addrules":
                    AddRules(context);
                    break;
                case "deleteRules":
                    DeleteRules(context);
                    break;
                case "editrules":
                    Editrules(context);break;
                case "fundinglist":
                    FundingList(context);break;
                case "addFunding":
                    AddFunding(context);break;
                case "fundingRefund":
                    FundingRefund(context);break;
                case "recoveryRules":
                    RecoveryRules(context);
                    break;
            }
        }

        private void RecoveryRules(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                int result = new BLL.FundRulesBll().UpdateState(id, "正常");

                if (result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
            }
            catch (Exception)
            {
                
                throw;
            }
        }

        private void FundingRefund(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                int result = new BLL.FundingBll().Refund(id);
                if (result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private static void AddFunding(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                
               
                var model = new Funding()
                                {
                                    Amount = Convert.ToDecimal(context.Request["amount"]),
                                    ClerkId = 0,
                                    CreateTime = DateTime.Now,
                                    Creator = new BLL.AdminBll().GetModel(context.User.Identity.Name).AdminId,
                                    ExpirationDate = DateTime.Now.AddYears(Convert.ToInt32(context.Request["Year"])),
                                    Year =  Convert.ToInt32(context.Request["Year"]),
                                    FundRulesId = Convert.ToInt32(context.Request["fundrules"]),
                                    InDate = Convert.ToDateTime(context.Request["Indate"]),
                                    Status = "正常", 
                                    UserId = Convert.ToInt32(context.Request["useraccount"])
                                };
                int result = new BLL.FundingBll().AddFunding(model);
                if(result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }

            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void FundingList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string compname = context.Request["compname"]??"";
            string status = context.Request["status"] ?? "";
            int creator = context.Request["creator"] == null ? 0 : Convert.ToInt32(context.Request["creator"]);
            string telphone = context.Request["telphone"] ?? "";
            int userId = string.IsNullOrEmpty(context.Request["userId"])
                             ? 0
                             : Convert.ToInt32(context.Request["userId"]);
            var list = new BLL.FundingBll().GetPageList1(telphone, compname, userId, creator, status, 0, pageSize, pageIndex, out count);

            int totalMoney = 0;
            int nowMoney = 0;
            if (list.Rows.Count > 0)
            {
                totalMoney = Convert.ToInt32(list.Rows[0]["totalMoney"]);
                nowMoney = Convert.ToInt32(list.Rows[0]["nowMoney"]);
            }
            var foot = new List<object>() { new { telphone = "金额总计：", Amount = totalMoney, InDate = "当前共有资金：", CreateTime = nowMoney, UserId = 0, adminName = " ", ExpirationDate = " ", } };

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
        }

        private void Editrules(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                var rules = new BLL.FundRulesBll().GetModel(id);
                rules.Cost = Convert.ToDecimal(context.Request["cost"]);
                rules.Name = context.Request["name"];
                rules.Num = Convert.ToInt32(context.Request["num"]);
                rules.ReferencePrice = Convert.ToInt32(context.Request["ReferencePrice"]);
                int result = new BLL.FundRulesBll().Update(rules);
                if(result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private static void DeleteRules(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);

                int result = new BLL.FundRulesBll().UpdateState(id, "已删除");

                if(result!=0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            
        }

        private static void AddRules(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                var model = new FundRules()
                                {
                                    Cost = Convert.ToDecimal(context.Request["cost"]),
                                    Name = context.Request["name"],
                                    Num = Convert.ToInt32(context.Request["num"]),
                                    ReferencePrice = Convert.ToInt32(context.Request["ReferencePrice"]),
                                    Status = "正常"
                                };
                int result = new BLL.FundRulesBll().Add(model);
                if(result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
           
        }

        private static void GetRulesList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string where = " 1=1 ";
            if(!string.IsNullOrEmpty(context.Request["Name"]))
            {
                where += " and Name LIKE '%" + context.Request["Name"] + "%'";
            }
            if (!string.IsNullOrEmpty(context.Request["ReferencePrice"]))
            {
                where += " and ReferencePrice=" + context.Request["ReferencePrice"];
            }
            if(!string.IsNullOrEmpty(context.Request["Status"]))
            {
                where += " and Status='" + context.Request["Status"] + "'";
            }

            var list = new BLL.FundRulesBll().GetPageList(where, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new {index = pageIndex, total = count, rows = list}));
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