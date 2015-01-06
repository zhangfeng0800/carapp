using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Order;
using Common;
using IEZU.Log;
using Model;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Statistics
{
    /// <summary>
    /// DriverData 的摘要说明
    /// </summary>
    public class DriverData : IHttpHandler
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly DirverAccountBLL _dirverAccountBll = new DirverAccountBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "driverListData":
                    GetDriverData(context);
                    break;
            }
            //context.Response.Write("Hello World");
        }

        #region 获取司机统计数据
        public void GetDriverData(HttpContext context)
        {
            int count = 0;
            string province = context.Request["province"] == null ? "13" : context.Request["province"];
            string city = context.Request["city"] == null ? "" : context.Request["city"];
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string orderby = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式
            DataSet ds = new DataSet();
            ds = _dirverAccountBll.GetDriverDataStatistics(province, city, orderby, sort, pageSize, pageIndex, out count);
            var list = ds.Tables[0];
            int num = 0;
            foreach (DataRow row in list.Rows)
            {
                if(row["proName"].ToString()=="未知")
                {
                    if(row["driverNum"].ToString() !=""){
                        num = Convert.ToInt32(row["driverNum"]);
                    }
                    else
                    {
                        num=0;
                    }
                }
                
            }
            DataTable dt = new DataTable();
            dt = ds.Tables[1];
            //服务总时长
            string str = (Convert.ToInt32(dt.Rows[0][3]) / 60).ToString() + "小时" + (Convert.ToInt32(dt.Rows[0][3]) % 60).ToString() + "分钟";
            var foot = new List<object>() { new { proName = "", cityName = "", driverNum = "司机人数：" + (Convert.ToInt32(dt.Rows[0][4]) - num).ToString() + " 人", totalKm = "服务总公里数：" + dt.Rows[0][0].ToString() + " Km", totalServerTime = "服务总时长：" + str + "", totalOrderNumber = "订单总数：" + dt.Rows[0][1].ToString() + "", totalOrderMoney = "订单总金额：" + dt.Rows[0][2].ToString() + " 元" } };
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));

        }
        #endregion

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}