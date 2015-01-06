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
using NPOI.HSSF.UserModel;
using System.Text;
using System.IO;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// DriverHandler 的摘要说明
    /// </summary>
    public class DriverHandler : IHttpHandler
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
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    ListData(context);//原来的方法 List(context);
                    break;
                case "carlist":
                    CarList(context);
                    break;
                case "orderlist":
                    OrderList(context);
                    break;
                case "DriverLogout":
                    DriverLogout(context);
                    break;
                case "recordlist":
                    Recordlist1(context);//原来的方法 Recordlist(context);
                    break;
                case "ToExcel":
                    GetDriverToExcel(context);//司机登录记录信息导出方法
                    break;
                case "DriverToExcel":
                    GetDriverListToExcel(context);//司机信息管理导出方法
                    break;
                case "DriverGo":
                    DriverGo(context);
                    break;
            }
        }

        public void DriverGo(HttpContext context)
        {
            try
            {
                var driverId = Convert.ToInt32(context.Request["driverId"]);

                new BLL.DirverAccountBLL().SetDriverGo(driverId);
            }
            catch (Exception exp)
            {
                LogHelper.WriteException(exp);
                context.Response.Write("-1");
            }
            
        }


        #region 司机登录退出查询--原来的方法
        private void Recordlist(HttpContext context)
        {
            string jobnumber = context.Request["id"];
            string driverName = context.Request["driverName"] ?? "";
            int rowcount = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            if (string.IsNullOrEmpty(dates))
                dates = DateTime.Now.ToString("yyyy-MM-dd");
            else
                dates = Convert.ToDateTime(dates).ToString("yyyy-MM-dd");
            if (string.IsNullOrEmpty(datee))
                datee = Convert.ToDateTime(DateTime.Now.AddDays(1).ToString("yyyy-MM-dd")).AddSeconds(-1).ToString("yyyy-MM-dd HH:mm:ss");
            else
                datee = Convert.ToDateTime(datee).ToString("yyyy-MM-dd") + " 23:59:59";
            var datatable = new BLL.DriverRecordBll().GetPage(pageSize, pageIndex, dates, datee, jobnumber, driverName, out rowcount);
            int minute = 0;
            if (datatable.Rows.Count > 0)
            {
                if (datatable.Rows[0]["totalMinute"].ToString() == "")
                {
                    minute = 0;
                }
                else
                {
                    minute = Convert.ToInt32(datatable.Rows[0]["totalMinute"]);
                }

            };

            var foot = new List<object>() { new { name = "", logoutTime = dates + " 到 " + datee.Substring(0, 10), logoutType = "登录总计：", onlinetime = minute } };

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowcount, rows = datatable, footer = foot }));
        }
        #endregion

        #region 司机登录退出查询--新方法
        private void Recordlist1(HttpContext context)
        {
            string jobnumber = context.Request["id"];
            string driverName = context.Request["driverName"] ?? "";
            int rowcount = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            string orderby = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式

            var datatable = new BLL.DriverRecordBll().GetPage1(pageSize, pageIndex, dates, datee, jobnumber, driverName,orderby,sort, out rowcount);
            int minute = 0;
            if (datatable.Rows.Count > 0)
            {
                if (datatable.Rows[0]["totalMinute"].ToString() == "")
                {
                    minute = 0;
                }
                else
                {
                    minute = Convert.ToInt32(datatable.Rows[0]["totalMinute"]);
                }

            };
            string str = "";
            if (dates == "" || datee == "")
            {
                str = "";
            }
            else
            {
                str = dates + " 到 " + datee.Substring(0, 10);
            }
            var foot = new List<object>() { new { name = "", logoutTime = str, logoutType = "登录总计：", onlinetime = minute } };
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowcount, rows = datatable, footer = foot }));
        }
        #endregion

        #region 强制退出
        private void DriverLogout(HttpContext context)
        {
            string carId = context.Request["carId"];
            string driverId = context.Request["driverId"];
            if (carId == "0")
            {
                context.Response.Write("-1");
            }
            else
            {
                var carbll = new BLL.CarInfoBLL();
                var carModel = carbll.GetModel(carId);
                carModel.DriverID = 0;

                LogHelper.WriteOperation("强制退出了司机ID：" + carModel.DriverID + " 车辆id:" + carModel.Id, OperationType.Update, "成功", context.User.Identity.Name);

                carbll.DriverLogOut(Int32.Parse(driverId), 2);
                if (carModel.carWorkStatus == Model.Enume.CarWorkStatus.canOrder)
                {
                    carbll.UpdateDirverId(Int32.Parse(carId), 0, 2);
                }
                else
                {
                    carbll.UpdateDirverId(Int32.Parse(carId), 0, (int)carModel.carWorkStatus);
                }

                ///记录司机退出状态
                new BLL.DriverRecordBll().UpdateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), "客服强制退出", new BLL.DirverAccountBLL().GetModel(Int32.Parse(driverId)).JobNumber);

                context.Response.Write("success");

            }

        }
        #endregion

        #region
        private void OrderList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string jobnumber = context.Request["id"];
            //string where = "jobnumber='" + jobnumber + "'";
            //var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count);
            var list = _orderBll.GetPageListByPro(0, 0, jobnumber, 0, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void CarList(HttpContext context)
        {
            var list = _carInfoBll.GetList("");
            context.Response.Write(JsonConvert.SerializeObject(list));
        }
        #endregion

        #region 添加司机信息
        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            var model = new DriverAccount();
            PostHelper.GetModel<DriverAccount>(ref model, context.Request.Form);
            if (_dirverAccountBll.IsExist(model.JobNumber))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此工号";
                LogHelper.WriteOperation("验证工号[" + model.JobNumber + "]", OperationType.Query, "工号存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                model.Pushuserid = "";
                model.Pushchannelid = "";
                model.CarNo = "0";
                try
                {
                    string url = ConfigurationManager.AppSettings["backUrl"];
                    model.Imgurl = url + model.Imgurl;
                    _dirverAccountBll.Add(model);
                    LogHelper.WriteOperation("添加工号[" + model.JobNumber + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                    message.Message = exception.Message;
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }
        #endregion

        #region 编辑
        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            var model = _dirverAccountBll.GetModel(id);
            PostHelper.GetModel<DriverAccount>(ref model, context.Request.Form);
            if (_dirverAccountBll.IsExist(model.JobNumber, id))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此工号";
                LogHelper.WriteOperation("验证工号[" + model.JobNumber + "]", OperationType.Query, "工号存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                if (string.IsNullOrEmpty(model.Pushuserid))
                {
                    model.Pushuserid = "";
                }
                if (string.IsNullOrEmpty(model.Pushchannelid))
                {
                    model.Pushchannelid = "";
                }
                model.CarNo = "0";
                try
                {
                    string url = ConfigurationManager.AppSettings["backUrl"];
                    if (!model.Imgurl.Contains(url) && !model.Imgurl.Contains("http://s.iezu.cn/"))
                        model.Imgurl = url + model.Imgurl;
                    _dirverAccountBll.Update(model);
                    message.IsSuccess = true;
                    message.Message = "";
                    LogHelper.WriteOperation("更新工号[" + model.JobNumber + "]", OperationType.Query, "更新成功", HttpContext.Current.User.Identity.Name);
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                    message.Message = exception.Message;
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }
        #endregion

        #region 原来的查询数据
        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string name = context.Request["scarno"] ?? "";
            string jobnumber = context.Request["jobnumber"] ?? "";
            string ssn = context.Request["txtid"] ?? "";//身份证号
            string sex = context.Request["sex"] ?? "";
            string province = context.Request["province"] ?? "";
            string city = context.Request["city"] ?? "";

            var list = new BLL.DirverAccountBLL().GetDriverPageListPro(province, city, name, jobnumber, ssn, sex,
                                                                       pageSize, pageIndex, out count);
            foreach (DataRow row in list.Rows)
            {
                if (!string.IsNullOrEmpty(row["birthday"].ToString()))
                {
                    row["age"] = DateTime.Now.Year - ((DateTime)row["birthday"]).Year;
                }
                if (!string.IsNullOrEmpty(row["getLicenseDay"].ToString()))
                {
                    row["DriverTime"] = DateTime.Now.Year - ((DateTime)row["getLicenseDay"]).Year;
                }
            }

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }
        #endregion

        #region 司机信息管理 加载数据
        /// <summary>
        /// 司机信息管理 加载数据  ljf新添加的方法
        /// 增加  司机登录状态和司机驾龄
        /// </summary>
        /// <param name="context"></param>
        private void ListData(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string name = context.Request["scarno"] ?? "";
            string jobnumber = context.Request["jobnumber"] ?? "";
            string ssn = context.Request["txtid"] ?? "";//身份证号
            string sex = context.Request["sex"] ?? "";
            string province = context.Request["province"] == null ? "13" : context.Request["province"]; //context.Request["province"] ?? "";
            string city = context.Request["city"] == null ? "" : context.Request["city"]; //context.Request["city"] ?? "";
            //ljf  begin  2014.10.28
            string driverState = context.Request["driverState"] ?? "";// 司机状态
            string driverTime = context.Request["driverTime"] ?? "";//司机驾龄   例如："1到3年"查询1到3年的驾龄

            string dates = context.Request["dates"] == null ? "" : context.Request["dates"]; //订单开始时间
            string datee = context.Request["datee"] == null ? "" : context.Request["datee"]; //订单结束时间

            string openID = context.Request["openID"] == null ? "" : context.Request["openID"];//是否绑定微信

            string isgo = context.Request["isgo"];
            string orderby = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            ds = new BLL.DirverAccountBLL().GetDriverPageListPro(province, city, name, jobnumber, ssn, sex, driverState, driverTime, orderby, sort, dates, datee,openID,
                                                                       pageSize, pageIndex,isgo, out count);
            var list = ds.Tables[0];
            dt = ds.Tables[1];
            int num = 0; //判断未知的那条数据
            foreach (DataRow row in list.Rows)
            {
                if (!string.IsNullOrEmpty(row["birthday"].ToString()))
                {
                    row["age"] = DateTime.Now.Year - ((DateTime)row["birthday"]).Year;
                }
                if (!string.IsNullOrEmpty(row["getLicenseDay"].ToString()))
                {
                    row["DriverTime"] = DateTime.Now.Year - ((DateTime)row["getLicenseDay"]).Year;
                }
            }
            //服务总时长
            string str = (Convert.ToInt32(dt.Rows[0][3]) / 60).ToString() + "小时" + (Convert.ToInt32(dt.Rows[0][3]) % 60).ToString() + "分钟";
            var foot = new List<object>() { new { name = "", cardno = "司机人数：", DriverTime = dt.Rows[0][4].ToString(), age = "总里程数：", ssn = dt.Rows[0][0].ToString() == "" ? "0" : dt.Rows[0][0].ToString() + " Km", carId = "订单总数量：", totalKm = dt.Rows[0][1].ToString() == "" ? "<span>0</span>" : "<span>" + dt.Rows[0][1].ToString() + "</span>", totalServerTime = "", totalOrderNumber = "订单总金额：", totalOrderMoney = dt.Rows[0][2].ToString() == "" ? "0" : dt.Rows[0][2].ToString(), openID = "foot", version = "服务总时长：", address = str } };
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
        }
        #endregion

        #region 司机信息管理导出
        public void GetDriverListToExcel(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = 100000;
            string name = context.Request["scarno"] ?? "";
            string jobnumber = context.Request["jobnumber"] ?? "";
            string ssn = context.Request["txtid"] ?? "";//身份证号
            string sex = context.Request["sex"] ?? "";
            string province = context.Request["province"] == null ? "13" : context.Request["province"]; //context.Request["province"] ?? "";
            string city = context.Request["city"] == null ? "" : context.Request["city"]; //context.Request["city"] ?? "";
            //ljf  begin  2014.10.28
            string driverState = context.Request["driverState"] ?? "";// 司机状态
            string driverTime = context.Request["driverTime"] ?? "";//司机驾龄   例如："1到3年"查询1到3年的驾龄

            string dates = context.Request["dates"] == null ? "" : context.Request["dates"]; //订单开始时间
            string datee = context.Request["datee"] == null ? "" : context.Request["datee"]; //订单结束时间
            string openID = context.Request["openID"] == null ? "" : context.Request["openID"];//是否绑定微信

            string orderby = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            ds = new BLL.DirverAccountBLL().GetDriverPageListPro(province, city, name, jobnumber, ssn, sex, driverState, driverTime, orderby, sort, dates, datee,openID,
                                                                       pageSize, pageIndex, "",out count);
            GetDriverListToExcel(ds);
        }

        #region 导出到Excel
        public void GetDriverListToExcel(DataSet ds)
        {
            var headerArray = new string[]
                                  {
                                      "工号", "司机姓名", "性别", "驾照编号", "驾龄 ", "密码", "年龄","身份证号","私人电话","登录状态","服务总里程(Km)","服务总时长","订单总数量","订单总金额","是否绑定微信","最后登录版本号","常住地址或者籍贯","其他"
                                  };
            var fileArray = new string[]
                                {
                                    "jobnumber", "name", "sex", "cardno", "drivertime","password", "age","ssn","driverPhone","carId","totalKm","totalServerTime","totalOrderNumber","totalOrderMoney","openID","version","address","other" 
                                };
            var workbook = new HSSFWorkbook();
            var sheet = (HSSFSheet)workbook.CreateSheet();
            sheet.DefaultColumnWidth = 20;
            //填充表头
            var dataRow = (HSSFRow)sheet.CreateRow(0);
            for (int i = 0; i < headerArray.Length; i++)
            {
                dataRow.CreateCell(i).SetCellValue(headerArray[i]);
            }
            //填充内容
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                dataRow = (HSSFRow)sheet.CreateRow(i + 1);

                for (int j = 0; j < fileArray.Length; j++)
                {
                    //drivertime  age
                    if (fileArray[j] == "drivertime")
                    {
                        var strDriverTime = DateTime.Now.Year - ((DateTime)ds.Tables[0].Rows[i]["getLicenseDay"]).Year;
                        dataRow.CreateCell(j).SetCellValue(strDriverTime.ToString());
                        continue;
                    }
                    else if (fileArray[j] == "age")
                    {
                        var strAge = DateTime.Now.Year - ((DateTime)ds.Tables[0].Rows[i]["birthday"]).Year;
                        dataRow.CreateCell(j).SetCellValue(strAge.ToString());
                        continue;
                    }
                    else if (fileArray[j] == "carId")
                    {
                        string isLogin = ds.Tables[0].Rows[i][fileArray[j]].ToString();
                        if (isLogin == "0")
                        {
                            dataRow.CreateCell(j).SetCellValue("否");
                        }
                        else
                        {
                            dataRow.CreateCell(j).SetCellValue(ds.Tables[0].Rows[i]["mycarNo"].ToString());
                        }
                        continue;
                    }
                    else if (fileArray[j] == "totalServerTime")
                    {
                        var inclass = ds.Tables[0].Rows[i][fileArray[j]].ToString();
                        //服务总时长

                        decimal a = Convert.ToDecimal(inclass);
                        int b = Convert.ToInt32(a);
                        string str = (b / 60).ToString() + "小时" + (b % 60).ToString() + "分钟";
                        if (!string.IsNullOrEmpty(inclass))
                        {
                            dataRow.CreateCell(j).SetCellValue(str);
                        }
                        continue;
                    }
                    else if (fileArray[j] == "totalOrderMoney")
                    {
                        var intype = ds.Tables[0].Rows[i][fileArray[j]].ToString();

                        if (!string.IsNullOrEmpty(intype))
                        {
                            dataRow.CreateCell(j).SetCellValue(intype + " 元");
                        }
                        continue;
                    }
                    else if (fileArray[j] == "openID")
                    {
                        string isWx = ds.Tables[0].Rows[i][fileArray[j]].ToString();
                        if (isWx == "" || isWx == null)
                        {
                            dataRow.CreateCell(j).SetCellValue("否");
                        }
                        else
                        {
                            dataRow.CreateCell(j).SetCellValue("是");
                        }
                        continue;
                    }

                    dataRow.CreateCell(j).SetCellValue(ds.Tables[0].Rows[i][fileArray[j]].ToString());
                }
            }

            #region 最后汇总
            //添加汇总
            dataRow = (HSSFRow)sheet.CreateRow(ds.Tables[0].Rows.Count + 3);
            dataRow.CreateCell(0).SetCellValue("合计：");
            //服务总时长
            string str1 = (Convert.ToInt32(ds.Tables[1].Rows[0][3]) / 60).ToString() + "小时" + (Convert.ToInt32(ds.Tables[1].Rows[0][3]) % 60).ToString() + "分钟";
            dataRow.CreateCell(1).SetCellValue("司机人数共：" + ds.Tables[1].Rows[0][4].ToString() + " 人");
            dataRow.CreateCell(10).SetCellValue("服务总公里数：" + ds.Tables[1].Rows[0][0].ToString() + " Km");
            dataRow.CreateCell(11).SetCellValue("服务总时长：" + str1 + "");
            dataRow.CreateCell(12).SetCellValue("订单总数：" + ds.Tables[1].Rows[0][1].ToString() + "");
            dataRow.CreateCell(13).SetCellValue("订单总金额：" + ds.Tables[1].Rows[0][2].ToString() + " 元");
            #endregion


            string strFileName = DateTime.Now.ToString("yyyyMMddhhmmss") + ".xls";
            HttpContext curContext = HttpContext.Current;

            // 设置编码和附件格式
            curContext.Response.ContentType = "application/vnd.ms-excel";
            curContext.Response.ContentEncoding = Encoding.UTF8;
            curContext.Response.Charset = "";
            curContext.Response.AppendHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(strFileName, Encoding.UTF8));
            // 保存
            using (var ms = new MemoryStream())
            {
                workbook.Write(ms);
                curContext.Response.BinaryWrite(ms.GetBuffer());
            }
            curContext.Response.End();
        }
        #endregion

        #endregion

        #region 司机登录记录统计导出功能
        /// <summary>
        /// 导出司机登录记录统计功能
        /// </summary>
        public void GetDriverToExcel(HttpContext context)
        {
            string jobnumber = context.Request["id"];
            string driverName = context.Request["driverName"] ?? "";
            int rowcount = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = 100000;
            string dates = context.Request["dates"];
            string datee = context.Request["datee"];
            string orderby = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式
            DataTable datatable = new DataTable();
            datatable = new BLL.DriverRecordBll().GetPage1(pageSize, pageIndex, dates, datee, jobnumber, driverName,orderby,sort, out rowcount);
            string[] headerArray = new string[]
                                  {
                                      "工号", "司机姓名", "登录时间", "退出时间", "退出方式", "本次登录时长"
                                  };
            string[] fileArray = new string[]
                                {
                                    "jobNumber", "name", "loginTime", "logoutTime", "logoutType","onlinetime"
                                };
            int minute = 0;
            if (datatable.Rows.Count > 0)
            {
                if (datatable.Rows[0]["totalMinute"].ToString() == "")
                {
                    minute = 0;
                }
                else
                {
                    minute = Convert.ToInt32(datatable.Rows[0]["totalMinute"]);
                }

            };
            string str = "";
            if (dates == "" || datee == "")
            {
                str = "";
            }
            else
            {
                str = dates + " 到 " + datee.Substring(0, 10);
            }

            ExportByWeb(datatable, headerArray, fileArray, true, str, minute);

        }
        #region 导出Excel方法
        /// <summary>
        ///   导出Excel方法
        /// </summary>
        /// <param name="dt">要导出的表</param>
        /// <param name="headerArray">导出显示的标题</param>
        /// <param name="fileArray">导出表的字段名称</param>
        /// <param name="flag">是否列有判断（如果有判断 在方法中添加判断）</param>
        public void ExportByWeb(DataTable dt, string[] headerArray, string[] fileArray, bool flag, string strDate, int minute)
        {

            var workbook = new HSSFWorkbook();
            var sheet = (HSSFSheet)workbook.CreateSheet();
            sheet.DefaultColumnWidth = 20;
            //填充表头
            var dataRow = (HSSFRow)sheet.CreateRow(0);
            for (int i = 0; i < headerArray.Length; i++)
            {
                dataRow.CreateCell(i).SetCellValue(headerArray[i]);
            }
            //填充内容
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dataRow = (HSSFRow)sheet.CreateRow(i + 1);

                for (int j = 0; j < fileArray.Length; j++)
                {
                    if (flag == true)
                    {
                        if (fileArray[j] == "onlinetime")
                        {
                            var inclass = dt.Rows[i][fileArray[j]].ToString() == "" ? "0" : dt.Rows[i][fileArray[j]].ToString();
                            //服务总时长
                            decimal a = Convert.ToDecimal(inclass);
                            int b = Convert.ToInt32(a);
                            string str = (b / 60).ToString() + "小时" + (b % 60).ToString() + "分钟";
                            if (!string.IsNullOrEmpty(inclass))
                            {
                                dataRow.CreateCell(j).SetCellValue(str);
                            }
                            continue;
                        }
                    }
                    dataRow.CreateCell(j).SetCellValue(dt.Rows[i][fileArray[j]].ToString());
                }
            }

            #region 最后汇总
            //添加汇总
            dataRow = (HSSFRow)sheet.CreateRow(dt.Rows.Count + 3);
            //服务总时长
            string str1 = (minute / 60).ToString() + "小时" + (minute % 60).ToString() + "分钟";
            dataRow.CreateCell(3).SetCellValue("从" + strDate + "");
            dataRow.CreateCell(4).SetCellValue("登录总时长：");
            dataRow.CreateCell(5).SetCellValue("" + str1 + "");
            #endregion

            string strFileName = DateTime.Now.ToString("yyyyMMddhhmmss") + ".xls";
            HttpContext curContext = HttpContext.Current;

            // 设置编码和附件格式
            curContext.Response.ContentType = "application/vnd.ms-excel";
            curContext.Response.ContentEncoding = Encoding.UTF8;
            curContext.Response.Charset = "";
            curContext.Response.AppendHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(strFileName, Encoding.UTF8));
            // 保存
            using (var ms = new MemoryStream())
            {
                workbook.Write(ms);
                curContext.Response.BinaryWrite(ms.GetBuffer());
            }
            curContext.Response.End();
        }
        #endregion
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