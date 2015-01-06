using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;
using Newtonsoft.Json;
using NPOI.HSSF.UserModel;

namespace CarAppAdminWebUI.Member
{
    public partial class UserExport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var _userAccountBll = new UserAccountBLL();
            int count = 0;
            int pageIndex = Convert.ToInt32(Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(Request["rows"] ?? "15");
            string order = Request["sort"] + " " + Request["order"];
            string username = Request["username"];
            string where = "username like '%" + username + "%' and compname like '%" +  Request["realname"] + "%' and telphone like '%" + Request["telphone"] + "%'";
            string times = Request["times"];
            string timee = Request["timee"];
            string isvip = Request["isvip"];
            if (Request["accountclass"] != "-1")
            {
                where += " and type=" + Request["accountclass"];
            }
            if (!string.IsNullOrEmpty(times) && !string.IsNullOrEmpty(timee))
            {
                where += " and registTime between '" + times + "' and '" + Convert.ToDateTime(timee).AddDays(1).AddMilliseconds(-1) + "' ";
            }

            if (order == " ")
                order = " id desc ";
            if (!string.IsNullOrEmpty(isvip))
            {
                where += " and isvip='" + isvip + "'";
            }

            var list = _userAccountBll.GetPageList(pageIndex, pageSize, order, where, out count);
            ExportByWeb(list);
        }
        public void ExportByWeb(List<UserAccount> dtSource)
        {
            var headerArray = new string[] { "手机号码" };
            var fileArray = new string[] { "telphone"};
         
            var workbook = new HSSFWorkbook();
            var sheet = (HSSFSheet)workbook.CreateSheet();
            //填充表头
            var dataRow = (HSSFRow)sheet.CreateRow(0);
            for (int i = 0; i < headerArray.Length; i++)
            {
                dataRow.CreateCell(i).SetCellValue(headerArray[i]);
            }
            //填充内容
            for (int i = 0; i < dtSource.Count; i++)
            {
                dataRow = (HSSFRow)sheet.CreateRow(i + 1);
                var telphone = dtSource[i].Telphone;
               

                dtSource[i].Telphone= telphone;

                for (int j = 0; j < fileArray.Length; j++)
                {
                    dataRow.CreateCell(j).SetCellValue(dtSource[i].Telphone);
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