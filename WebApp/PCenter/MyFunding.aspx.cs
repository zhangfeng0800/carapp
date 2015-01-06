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
    public partial class MyFunding : PageBase.PageBase
    {
        protected decimal FundingMoney = 0;
        protected int totalPage = 10;
        protected DataTable vouchers; //代金券列表
        protected DataTable vouCount; //数目
        protected DataTable fundingList;//基金列表
        protected decimal userMoney;
        protected List<Model.FundRules> list;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (userAccount.IsHideFunding == 1)
            {
                Response.Write("错误页面");
                Response.End();
                return;
            }

            if(!IsPostBack)
            {
                int cou = 0;
                userMoney = new BLL.UserAccountBLL().GetModel(userAccount.Id).Balance;
                list = new BLL.FundRulesBll().GetPageList("ReferencePrice>0 and [Status]='正常' and  ReferencePrice<=" + userMoney, " ReferencePrice desc ", 20, 1, out cou);
               
            }
         
            var vouchersBll = new BLL.VouchersBll();
            var fundingBLl = new BLL.FundingBll();
            int pageSize = 10;
            int count = 0;
            if(Request["pageIndex"] == null)
            {
                FundingMoney = fundingBLl.GetFundingMoney(userAccount.Id);
                vouCount = vouchersBll.GetUseCount(userAccount.Id);
                vouchers = vouchersBll.GetPageList("",userAccount.Id, 0, "未使用", 1, pageSize, 1, out count);
                totalPage = Convert.ToInt32(Math.Ceiling(count / (double)pageSize));
                int rowcount = 0;
                fundingList = fundingBLl.GetPageList("", userAccount.Id, 0, "", 0, 5, 1, out rowcount);
            }
            else
            {
                int pageIndex = Int32.Parse(Request["pageIndex"]);
                int type = Int32.Parse(Request["Type"]);
                switch (type)
                {
                    case 1: //可用
                        vouchers = vouchersBll.GetPageList("",userAccount.Id, 0, "未使用", 1, pageSize, pageIndex, out count);
                        break;
                    case 2://已用，则type为0显示全部，状态为已使用
                         vouchers =vouchersBll.GetPageList("",userAccount.Id, 0, "已使用", 0, pageSize, pageIndex, out count);
                        break;
                    case 3: //已失效 type为2显示失效
                         vouchers = vouchersBll.GetPageList("",userAccount.Id, 0, "未使用", 2, pageSize, pageIndex, out count);
                        break;
                }
         
                Response.Write(JsonConvert.SerializeObject(new
                {
                    rowCount = count,
                    data = vouchers
                }));
                Response.End();
            }
            

        }
    }
}