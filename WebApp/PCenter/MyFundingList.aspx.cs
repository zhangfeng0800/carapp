using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyFundingList : PageBase.PageBase
    {
        protected DataTable fundingList;//基金列表
        protected int totalPage;
        protected void Page_Load(object sender, EventArgs e)
        {
            int rowcount = 0;
            int pageSize = 10;
            var fundingBLl = new BLL.FundingBll();
            if (Request["pageIndex"] == null)
            {
                fundingList = fundingBLl.GetPageList("", userAccount.Id, 0, "", 0, pageSize, 1, out rowcount);
                totalPage = Convert.ToInt32(Math.Ceiling(rowcount / (double)pageSize));
            }
            else
            {
                fundingList = fundingBLl.GetPageList("", userAccount.Id, 0, "", 0, pageSize, Int32.Parse(Request["pageIndex"]), out rowcount);
                totalPage = Convert.ToInt32(Math.Ceiling(rowcount / (double)pageSize));
                Response.Write(JsonConvert.SerializeObject(new
                {
                    rowCount = rowcount,
                    data = fundingList
                }));
                Response.End();
            }
           
        }
    }
}