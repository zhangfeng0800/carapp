using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common;

namespace WebApp.api
{
    /// <summary>
    /// JenayAccount 的摘要说明
    /// </summary>
    public class JenayAccount : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(context, action);
        }

        public void Routing(HttpContext context, string action)
        {
            switch (action)
            {
                case "GetList": GetList(context); break;
                case "GetDataByTime": GetDataByTime(context); break;
                default:
                    break;
            }
        }

        public void GetList(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            int pageRowCount = 5;
            var result = BLL.AccountBLL.GetList(userId);
            int count = result.Count;
            int pageCount = count / 5;
            var result2 = result.Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            string responseText = "";
            foreach (var item in result2)
            {
                decimal moneyIn = 0.00M;
                decimal moneyOut = 0.00M;
                if (item.Type == PayType.Income)
                {
                    moneyIn = item.Money;
                }
                else if (item.Type ==PayType.Pay)
                {
                    moneyOut = item.Money;
                }
                responseText += " <tr>                        ";
                responseText += " <td>" + item.AccountNumber + "</td>     ";
                responseText += " <td>" + item.Datetime.ToString("yyyy-MM-dd hh:mm") + "</td>     ";
                responseText += " <td>" + moneyIn + "</td> ";
                responseText += " <td>" + moneyOut + "</td> ";
                responseText += " <td>" + item.Balance + "</td> ";
                responseText += " <td><a href='#'>查看详情</a></td> ";
                responseText += "</tr>";
            }
            context.Response.Write(responseText + "|" + count + "|" + pageCount);
        }
        public void GetDataByTime(HttpContext context)
        {
            DateTime startTime = Convert.ToDateTime(context.Request["startTime"]).Date;
            DateTime overTime = Convert.ToDateTime(context.Request["overTime"]).Date;
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            int pageRowCount = 5;
            var result = BLL.AccountBLL.GetList(userId);
            result = result.Where(s => s.Datetime >= startTime && s.Datetime <= overTime).ToList();
            int count = result.Count;
            int pageCount = count / 5;
            var result2 = result.Skip((currentPage - 1) * pageRowCount).Take(pageRowCount);
            string responseText = "";
            foreach (var item in result2)
            {
                decimal moneyIn = 0.00M;
                decimal moneyOut = 0.00M;
                if (item.Type == PayType.Income)
                {
                    moneyIn = item.Money;
                }
                else if (item.Type ==PayType.Pay)
                {
                    moneyOut = item.Money;
                }
                responseText += " <tr>                        ";
                responseText += " <td>" + item.AccountNumber + "</td>     ";
                responseText += " <td>" + item.Datetime.ToString("yyyy-MM-dd hh:mm") + "</td>     ";
                responseText += " <td>" + moneyIn + "</td> ";
                responseText += " <td>" + moneyOut + "</td> ";
                responseText += " <td>" + item.Balance + "</td> ";
                responseText += " <td><a href='#'>查看详情</a></td> ";
                responseText += "</tr>";
            }
            context.Response.Write(responseText + "|" + count + "|" + pageCount);
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