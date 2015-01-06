using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// CheckAccountBalance 的摘要说明
    /// </summary>
    public class CheckAccountBalance : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (!string.IsNullOrEmpty(context.Request["telphone"]) && !string.IsNullOrEmpty(context.Request["rentcarid"]) && !string.IsNullOrEmpty(context.Request["ordernum"]))
            {
                var telphone = context.Request["telphone"];
                var rentcarid = context.Request["rentcarid"];
                var ordernum = int.Parse(context.Request["ordernum"]);
                var useraccount = (new UserAccountBLL()).GetModel(telphone);
                if (useraccount == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "账户不存在" }));
                    return;
                }
                var rentModel = (new RentCarBLL()).GetModel(int.Parse(rentcarid));
                if (rentModel == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "租车信息不存在" }));
                    return;
                }
                context.Response.Write(useraccount.Balance >= (rentModel.DiscountPrice * ordernum)
                    ? JsonConvert.SerializeObject(new { resultcode = 1 })
                    : JsonConvert.SerializeObject(
                        new
                        {
                            resultcode = -1,
                            currentbalance = useraccount.Balance,
                            ordermoney = rentModel.DiscountPrice
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