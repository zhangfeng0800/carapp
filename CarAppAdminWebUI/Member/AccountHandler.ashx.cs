using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// 流水信息处理程序
    /// </summary>
    public class AccountHandler : IHttpHandler
    {
        private readonly AccountBLL _account = new AccountBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "accountstatistics":
                    Accountstatistics(context);
                    break;
            }
        }

        private void Accountstatistics(HttpContext context)
        {
              int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            string compname = context.Request["compname"];
            string telphone = context.Request["telphone"];
            string orderby = Common.Tool.GetString(context.Request["sort"]);
            string sort = Common.Tool.GetString(context.Request["order"]);

            var data = new BLL.UserAccountBLL().GetUserStatistics(compname,telphone,dates,datee,orderby,sort,pageSize,pageIndex,out count);
            if (data.Rows.Count > 0)
            {
                var foot = new List<object>() { new { compname = "", 存费赠券活动  = "总计：", 银联无卡支付 = "银联总计：", 银联手机支付 = data.Rows[0]["upopMoney"], 支付宝充值 = "支付宝总计：",
            网银充值=data.Rows[0]["alipayMoney"],易宝手机支付="易宝总计：",易宝PC支付=data.Rows[0]["yeepayMoney"],使用充值卡="充值卡："+data.Rows[0]["giftcardMoney"],充值送车费="送车费："+data.Rows[0]["chargeSendMoney"],二次付款 ="退款总计：",订单退款 =data.Rows[0]["backMoney"],净充值=data.Rows[0]["chargeMoney"],
            微信分享摇奖活动="抽奖金额："+data.Rows[0]["lotteryMoney"],赠送金额=data.Rows[0]["giftMoney"],总充值=data.Rows[0]["allChargeMoney"],总消费=data.Rows[0]["allMoney"]} };
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = data, footer = foot }));
            }
            else
            {
                var foot = new List<object>() { new { compname = "", 存费赠券活动  = "总计：", 银联无卡支付 = "银联总计：", 银联手机支付 = 0, 支付宝充值 = "支付宝总计：",
            网银充值=0,易宝手机支付="易宝总计：",易宝PC支付=0,二次付款 ="退款总计：",订单退款 =0,净充值=0,使用充值卡="充值卡："+0,充值送车费="送车费："+0,微信分享摇奖活动="抽奖金额："+0,
            赠送金额=0,总充值=0,总消费=0} };
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = data, footer = foot }));
            }
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string startdate = Common.Tool.SqlFilter(context.Request["startDate"]);
            string enddate =  Common.Tool.SqlFilter(context.Request["endDate"]);
            string username =   Common.Tool.SqlFilter(context.Request["username"]);

            string accountNumber =   Common.Tool.SqlFilter(context.Request["keyword"]);

            string operationtype =  Common.Tool.SqlFilter(context.Request["operationtype"]);

            var list = _account.GetPageListPro(startdate, enddate, operationtype, username, accountNumber, pageIndex, pageSize, out count);

           // var foot = new List<object>() { new { datetime = startdate + " 到 " + enddate, money = list.Rows[0]["totalPay"], inMoney = list.Rows[0]["totalIn"] } };

           // var list = _account.GetPageList(pageIndex, pageSize,order, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
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