using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// GiftCardsHandler 的摘要说明
    /// </summary>
    public class GiftCardsHandler : IHttpHandler
    {
        private readonly GiftCards _giftCards = new GiftCards();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
                case "export":
                    SetPrint(context);//设为打印状态
                    break;
            }
        }
        private void SetPrint(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string ids = context.Request["ids"];
            _giftCards.SetPrint(ids);
            message.IsSuccess = true;
            message.Message = "";
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string ids = context.Request["ids"];
                _giftCards.Delete(ids);
                LogHelper.WriteOperation("删除编号为[" + ids + "]的充值卡", OperationType.Delete, "删除成功", HttpContext.Current.User.Identity.Name);
                message.IsSuccess = true;
                message.Message = "";

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.IsSuccess = false;
            }
            context.Response.Write(JsonConvert.SerializeObject(message));

        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int cost = Convert.ToInt32(context.Request["Cost"]);
                if (cost < 1)
                {
                    message.IsSuccess = false;
                    message.Message = "充值卡面值过小";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (cost > 10000000)
                {
                    message.IsSuccess = false;
                    message.Message = "充值卡面值过大";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                string name = context.Request["name"];
                int count = Convert.ToInt32(context.Request["count"]);
                if (name.Length > 16)
                {
                    message.IsSuccess = false;
                    message.Message = "充值卡名称不大于16个汉字";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (count == 0)
                {
                    message.IsSuccess = false;
                    message.Message = "充值卡数量应大于0";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }

                else
                {
                    int saleManId = Convert.ToInt32(context.Request["saleManId"]); //领卡人Id
                    int numberBegin = Convert.ToInt32(context.Request["numberBegin"]);
                    int cardType = Convert.ToInt32(context.Request["cardType"]);

                    _giftCards.Add(name, cost,  saleManId,numberBegin, cardType,count,context.User.Identity.Name);

                    }
                    message.IsSuccess = true;
                    message.Message = "";
                }

            
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.Message = exception.Message;
                message.IsSuccess = false;
            }

            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            int number = string.IsNullOrEmpty(context.Request["number"]) ? 0 : Convert.ToInt32(context.Request["number"]);
            int numberend = string.IsNullOrEmpty(context.Request["numberend"]) ? 0 : Convert.ToInt32(context.Request["numberend"]);
            int status = string.IsNullOrEmpty(context.Request["status"])? 0:Convert.ToInt32(context.Request["status"]);
            string name = context.Request["name"]??"";
            int cost = string.IsNullOrEmpty(context.Request["cost"])? 0:Convert.ToInt32(context.Request["cost"]);
            string no = context.Request["no"]??"";
            int isExport = string.IsNullOrEmpty(context.Request["IsExport"])? 0:Convert.ToInt32(context.Request["IsExport"]);
            string times = context.Request["times"]??"";
            string timee = context.Request["timee"]??"";
            string saleman = context.Request["saleman"]??"";

            string compname = context.Request["compname"]??"";

            string telphone = context.Request["telphone"] ?? "";

            //string where = "1=1";
            //if (!string.IsNullOrEmpty(status))
            //{
            //    where += " and Status=" + status;
            //}
            //if (!string.IsNullOrEmpty(isExport))
            //{
            //    where += " and IsExport=" + isExport;
            //}
            //if (!string.IsNullOrEmpty(name))
            //{
            //    where += " and name like '%" + Common.Tool.SqlFilter(name) + "%'";
            //}
            //if (!string.IsNullOrEmpty(cost))
            //{
            //    where += " and cost ='" + Common.Tool.SqlFilter(cost) + "'";
            //}
            //if (!string.IsNullOrEmpty(no))
            //{
            //    where += " and sn like '%" + Common.Tool.SqlFilter(no) + "%'";
            //}

            //if (times != "" && timee != "")
            //{
            //    where += " and useTime between '" + times + "' and '" + timee + "' ";
            //}

            //var list = _giftCards.GetList(pageIndex, pageSize, where, out count);
            var list = _giftCards.GetPageListPro(number, name, cost, no, status, isExport, times, timee, saleman, pageSize,
                                                 pageIndex, out count, compname, telphone, numberend);
            context.Response.Write(
                JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
        }

        public string GenerateUniqueText(int num)
        {
            string randomResult = string.Empty;
            string readyStr = "123456789ABCDEFGHIJKLMNPQRSTUVWXYZ";
            char[] rtn = new char[num];
            Guid gid = Guid.NewGuid();
            var ba = gid.ToByteArray();
            for (var i = 0; i < num; i++)
            {
                rtn[i] = readyStr[((ba[i] + ba[num + i]) % readyStr.Length)];
            }
            foreach (char r in rtn)
            {
                randomResult += r;
            }
            return randomResult;
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