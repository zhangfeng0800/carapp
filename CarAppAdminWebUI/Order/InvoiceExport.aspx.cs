using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.HSSF.UserModel;

namespace CarAppAdminWebUI.Order
{
    public partial class InvoiceExport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int count = 0;
            int pageIndex = 1;
            int pageSize = 1000;
            string orderid = Request["orderid"] ?? "";
            int invoiceStatus = string.IsNullOrEmpty(Request["invoiceStatus"]) ? 0 : Convert.ToInt32(Request["invoiceStatus"]);
            string where = "";

            var data = new BLL.OrderInvoiceBll().GetOrderInvoicePage(invoiceStatus, 0, 6, orderid, pageSize, pageIndex,
                                                                     out count);
            ExportByWeb(data);
        }

        public void ExportByWeb(DataTable dtSource)
        {
            var headerArray = new string[]
                                  {
                                      "订单编号", "用户名", "电话", "总额（元）", "发票类型", "发票抬头", "发票内容", "邮寄地址", "邮政编码", "公司账号", "公司地址",
                                      "开户银行", "联系电话", "纳税标识", "邮寄状态"
                                  };
            var fileArray = new string[]
                                {
                                    "orderId", "passengerName", "passengerPhone", "totalMoney", "invoiceClass",
                                    "invoiceHead", "invoiceType", "invoiceAdress", "invoiceZipCode", "CompAccount",
                                    "CompAdd", "CompBank",
                                    "CompTel", "TaxpayerID", "status"
                                };
            var invoiceClass = new string[] { "增值税专用发票", "普通发票" }; //发票类型
            var invoiceType = new string[] { "租赁费", "租赁服务费", "汽车租赁费", "代驾服务费" }; //发票内容
            var status = new string[] { "未邮寄", "已邮寄", "已取消" }; //邮寄状态

            var workbook = new HSSFWorkbook();
            var sheet = (HSSFSheet)workbook.CreateSheet();
            //填充表头
            var dataRow = (HSSFRow)sheet.CreateRow(0);
            for (int i = 0; i < headerArray.Length; i++)
            {
                dataRow.CreateCell(i).SetCellValue(headerArray[i]);
            }
            //填充内容
            for (int i = 0; i < dtSource.Rows.Count; i++)
            {
                dataRow = (HSSFRow)sheet.CreateRow(i + 1);

                for (int j = 0; j < fileArray.Length; j++)
                {
                    if (fileArray[j] == "invoiceClass")
                    {
                        var inclass = dtSource.Rows[i][fileArray[j]].ToString();
                        if (!string.IsNullOrEmpty(inclass))
                        {
                            dataRow.CreateCell(j).SetCellValue(
                            invoiceClass[Int32.Parse(inclass) - 1]);
                        }
                        continue;
                    }
                    else if (fileArray[j] == "invoiceType")
                    {
                        var intype = dtSource.Rows[i][fileArray[j]].ToString();
                        if (intype == "0")
                        {
                            dataRow.CreateCell(j).SetCellValue("未知类型");
                            continue;
                        }
                        if (!string.IsNullOrEmpty(intype))
                        {
                            dataRow.CreateCell(j).SetCellValue(
                            invoiceType[Int32.Parse(intype) - 1]);
                        }
                        continue;
                    }
                    else if (fileArray[j] == "status")
                    {
                        var state = dtSource.Rows[i][fileArray[j]].ToString();
                        if (!string.IsNullOrEmpty(state))
                        {
                            dataRow.CreateCell(j).SetCellValue(
                            status[Int32.Parse(state)]);
                        }
                        continue;
                    }

                    dataRow.CreateCell(j).SetCellValue(dtSource.Rows[i][fileArray[j]].ToString());
                }
            }

            string strFileName = DateTime.Now.ToString("yyyyMMddhhmmss") + ".xls";
            HttpContext curContext = HttpContext.Current;

            // 设置编码和附件格式
            curContext.Response.ContentType = "application/vnd.ms-excel";
            curContext.Response.ContentEncoding = Encoding.UTF8;
            curContext.Response.Charset = "";
            curContext.Response.AppendHeader("Content-Disposition",
                "attachment;filename=" + HttpUtility.UrlEncode(strFileName, Encoding.UTF8));
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