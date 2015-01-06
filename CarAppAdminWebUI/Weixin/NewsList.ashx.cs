using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Weixin
{
    /// <summary>
    /// NewsList 的摘要说明
    /// </summary>
    public class NewsList : IHttpHandler
    {
        private readonly WxNewsBLL _wxNewsBll = new WxNewsBLL();
        public void ProcessRequest(HttpContext context)
        {
            string action = context.Request["action"].ToString() ;
            switch (action)
            { 
                case "add":
                    AddSend(context);                  
                    break;
                case "del":
                    Dele(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "setSend":
                    SetSend(context);
                    break;
                case "carlifelist":
                    GetCarLifeList(context);
                        break;
                case "setLottery":
                        SetLottery(context);
                        break;
                case "cancelLottery":
                        CancelLottery(context);
                        break;
                case "setLotteryOrder":
                        SetLotteryOrder(context);
                        break;
                case "SetLotteryAll":
                        SetLotteryAll(context);
                        break;
            }
        }

        private void SetLotteryAll(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["ID"]);
            int result = new BLL.WxNewsChildrenBLL().UpdateLottery(id, 5);
            if (result != 0)
            {
                context.Response.Write("success");
            }
        }

        private void SetLotteryOrder(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["ID"]);
            int result = new BLL.WxNewsChildrenBLL().UpdateLottery(id, 2);
            if (result != 0)
            {
                context.Response.Write("success");
            }
        }

        private void CancelLottery(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["ID"]);
            int result = new BLL.WxNewsChildrenBLL().UpdateLottery(id, 0);
            if (result != 0)
            {
                context.Response.Write("success");
            }
        }

        private void SetLottery(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["ID"]);
            int result = new BLL.WxNewsChildrenBLL().UpdateLottery(id, 1);
            if (result != 0)
            {
                context.Response.Write("success");
            }
        }

        private void GetCarLifeList(HttpContext context)
        {
             int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var list = new BLL.WxNewsChildrenBLL().GetPageList(pageIndex, pageSize, "", out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = 1, total = count, rows = list }));
        }

        private void SetSend(HttpContext context)
        {
            int id = Int32.Parse(context.Request["ID"]);
            _wxNewsBll.UpdateState(id);
        }

        private void List(HttpContext context)
        {
            string keyword = context.Request["Keyword"];
            string type = context.Request["type"];
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string sort = context.Request["sort"] + " " + context.Request["order"];
            string where = " 1=1 ";
            if (!string.IsNullOrEmpty(type))
            {
                if(type == "not")
                where += " and type <> '租车生活'";
                else
                    where += " and type='" + type + "'";
            }

            if (sort == " ")
            {
                sort = " id desc ";
            }

            var list = _wxNewsBll.GetPageList(pageIndex, pageSize,sort, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = 1, total = count, rows = list }));

        }

        private void Dele(HttpContext context)
        {
            int id = Int32.Parse(context.Request["ID"]);
            if (id == 1)
                context.Response.Write("0");
            else
                context.Response.Write(new BLL.WxNewsBLL().DeleteData(id));
        }

        private void AddSend(HttpContext context)
        {
            string type = "群发图文";
            if (!string.IsNullOrEmpty(context.Request["type"]))
                type = context.Request["type"].ToString();
            else
                type = "群发图文";
            int id = _wxNewsBll.AddData(new Model.WxNews { CreateTime = DateTime.Now, State = "未发送", Type = type });
            context.Response.Write(id);
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