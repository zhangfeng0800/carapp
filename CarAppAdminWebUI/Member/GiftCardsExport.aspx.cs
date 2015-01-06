using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using BLL;
using NPOI.HSSF.UserModel;

namespace CarAppAdminWebUI.Member
{
    public partial class GiftCardsExport : System.Web.UI.Page
    {
        private readonly GiftCards _giftCards = new GiftCards();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["action"] == null) //导出充值卡
            {
                var name = Request.QueryString["cardname"];
                string state = Request.QueryString["state"];
                var startid = Request.QueryString["startid"];
                var endid = Request.QueryString["endid"];
                var start = 0;
                var end = 0;
                if (!int.TryParse(startid, out start))
                {
                    start = 0;
                }
                if (!int.TryParse(endid, out end))
                {
                    end = 0;
                }
                DataTable da = _giftCards.ExportData(name, state, start, end);

                // DataTable dataTable = _giftCards.GetTable(where);
                ExportByWeb(da,"giftcard");
            }
            else
            {
                var name = Request.QueryString["cardname"]??"";
                var startid = Request.QueryString["idStart"];
                var endid = Request.QueryString["idEnd"];
                var state = Request.QueryString["state"]??"";

                DataTable da = new BLL.Coupon().ExportData(name, startid, endid, state);

                ExportByWeb(da, "coupon");
            }
        }

        public void ExportByWeb(DataTable dtSource,string type)
        {
            var headerArray = new string[] { "编号", "名称", "序列号", "面额", "使用状态", "领卡人", "操作人" };
            var fileArray = new string[] { "id", "name", "sn", "cost", "Status", "saleman", "created" };
            if (type == "giftcard")
            {
                headerArray = new string[] { "编号", "名称", "序列号", "面额", "使用状态", "领卡人", "操作人" };
                fileArray = new string[] { "id", "name", "sn", "cost", "Status", "saleman", "created" };
            }
            else
            {
                headerArray = new string[] { "编号", "名称", "序列号", "面额", "所需消费", "使用状态" };
                fileArray = new string[] { "id", "name", "sn", "cost", "Restrictions", "Status" };
            }
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
                var sn = dtSource.Rows[i]["sn"].ToString();
                var newsn = "";
                if (sn.Contains("-"))
                {
                    newsn = sn;
                }
                else
                {
                    if (sn.Length == 12)
                    {
                       newsn = sn.Substring(0, 4) + " " + sn.Substring(4, 4) + " " + sn.Substring(8, 4); 
                    }
                    else
                    {
                        newsn = sn;
                    }
                }

                dtSource.Rows[i]["sn"] = newsn;

                for (int j = 0; j < fileArray.Length; j++)
                {
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