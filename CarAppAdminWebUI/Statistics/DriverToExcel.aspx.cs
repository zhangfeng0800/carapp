using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BLL;
using NPOI.HSSF.UserModel;
using System.Text;
using System.IO;

namespace CarAppAdminWebUI.Statistics
{
    public partial class DriverToExcel : System.Web.UI.Page
    {
        private readonly DirverAccountBLL _dirverAccountBll = new DirverAccountBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            int count = 0;
            string province = Request["province"] == null ? "13" : Request["province"];
            string city = Request["city"] == null ? "" : Request["city"];
            string orderby = "totalKm";  //排序字段
            string sort = "desc";    //排序方式
            int pageIndex = 1;
            int pageSize = 10000;
            DataSet ds = new DataSet();
            ds = _dirverAccountBll.GetDriverDataStatistics(province, city, orderby, sort, pageSize, pageIndex, out count);
            //var data = ds.Tables[0];
            int num = 0;
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if (row["proName"].ToString() == "未知")
                {
                    if (row["driverNum"].ToString() != "")
                    {
                        num = Convert.ToInt32(row["driverNum"]);
                    }
                    else
                    {
                        num = 0;
                    }
                }

            }
            ExportByWeb(ds, num);
        }

        public void ExportByWeb(DataSet ds, int num)
        {
            var headerArray = new string[]
                                  {
                                      "省份", "城市", "司机人数", "服务总公里数(Km) ", "服务总时长 ", "订单总数", "订单总金额(元) "
                                  };
            var fileArray = new string[]
                                {
                                    "proName", "cityName", "driverNum", "totalKm", "totalServerTime","totalOrderNumber", "totalOrderMoney"
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
                    if (fileArray[j] == "driverNum")
                    {
                        var pro = ds.Tables[0].Rows[i]["proName"].ToString();
                        if (pro == "未知")
                        {
                            dataRow.CreateCell(j).SetCellValue("");
                        }
                        else
                        {
                            dataRow.CreateCell(j).SetCellValue(ds.Tables[0].Rows[i][fileArray[j]].ToString());
                        }
                        continue;
                    }
                    if (fileArray[j] == "totalServerTime")
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

                    dataRow.CreateCell(j).SetCellValue(ds.Tables[0].Rows[i][fileArray[j]].ToString());
                }
            }

            #region 最后汇总
            //添加汇总
            dataRow = (HSSFRow)sheet.CreateRow(ds.Tables[0].Rows.Count + 3);
            //服务总时长
            string str1 = (Convert.ToInt32(ds.Tables[1].Rows[0][3]) / 60).ToString() + "小时" + (Convert.ToInt32(ds.Tables[1].Rows[0][3]) % 60).ToString() + "分钟";
            dataRow.CreateCell(2).SetCellValue("司机人数共：" + (Convert.ToInt32(ds.Tables[1].Rows[0][4]) - num).ToString() + " 人");
            dataRow.CreateCell(3).SetCellValue("服务总公里数：" + ds.Tables[1].Rows[0][0].ToString() + " Km");
            dataRow.CreateCell(4).SetCellValue("服务总时长：" + str1 + "");
            dataRow.CreateCell(5).SetCellValue("订单总数：" + ds.Tables[1].Rows[0][1].ToString() + "");
            dataRow.CreateCell(6).SetCellValue("订单总金额：" + ds.Tables[1].Rows[0][2].ToString() + " 元");
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
    }
}