using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using System.Data;
using System.Data.SqlClient;
using IEZU.Log;
using Model;
using System.Web.Security;
using System.IO;
using System.Text;
using Newtonsoft.Json;
using DBUtility;
namespace WebApp.twicepay
{
    /// <summary>
    /// twicePay 的摘要说明
    /// </summary>
    public class twicePay : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string action = context.Request["action"];
            Routing(action, context);
        }

        public void Routing(string action, HttpContext context)
        {
            if (string.IsNullOrEmpty(action))
            {
                Check(context);
            }
            else if (action == "getJson")
            {
                GetJson(context);
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public void Check(HttpContext context)
        {

        }
        public void GetJson(HttpContext context)
        {
            string orderid = context.Request.Form["orderid"].ToString();
            DataTable dt = (new OrderBLL()).GetOrderById(orderid);
            if (dt.Rows.Count == 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    ordererror = "noid"
                }));
                return;
            }
            string orderdate = Convert.ToDateTime(dt.Rows[0]["orderdate"].ToString()).ToString("yyyyMMddHHmmss");
            if (orderdate != orderid.Substring(0, orderid.Length - 5))
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    ordererror = "noid"
                }));
                return;

            }
            int identitytype = 0;
            string Json = "";
            string identityid = dt.Rows[0]["userID"].ToString();
            Json = GetBankList(identityid, identitytype);
            if (Json.Contains("error_code") || Json == "")
            {
                context.Response.Write(JsonConvert.SerializeObject(new { data = "error" }));
            }
            else
            {
                context.Response.Write(Json);
            }
        }
        #region 易宝绑卡请求
        public string GetBankList(string identityid, int identitytype)
        {
            try
            {
                YJPay yjpay = new YJPay();
                string res = yjpay.getBindList(identityid, identitytype);
                return res;
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                return "";
            }
        }
        #endregion
    }
}