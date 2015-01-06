using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyCoupon : PageBase.PageBase
    {
        protected List<Model.Coupon> CoupList = new List<Model.Coupon>();
        protected int MaxCount = 0;
        public int totalPage = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            int pageSize = 10;
            if (Request["status"] == null)
            {
                BLL.Coupon CB = new BLL.Coupon();
                CoupList = CB.GetList(1, pageSize, " userId=" + userAccount.Id + " and [Status]=0 ", out MaxCount);
                    //CB.GetList(userAccount.Id, pageSize, Common.Tool.GetInt(Request.QueryString["Previous"]), Common.Tool.GetInt(Request.QueryString["Status"]), out MaxCount);

                totalPage = Convert.ToInt32(Math.Ceiling(MaxCount / (double)pageSize));
            }
            else
            {
                    int pageIndex = Convert.ToInt32(Request["pageIndex"]);
                    BLL.Coupon CB = new BLL.Coupon();
                    if(Request["status"]=="2")
                        CoupList = CB.GetList(pageIndex, pageSize, " userId=" + userAccount.Id + " and [Status]=0 and Deadline<'"+DateTime.Now+"'", out MaxCount);
                    else
                        CoupList = CB.GetList(pageIndex, pageSize, " userId=" + userAccount.Id + " and [Status]=" + Common.Tool.GetInt(Request["status"]), out MaxCount);
                    //CoupList = CB.GetList(userAccount.Id, 10, pageSize * pageIndex, Common.Tool.GetInt(Request["status"]), out MaxCount);
                    Response.Write(JsonConvert.SerializeObject(new
                    {
                        data = CoupList,
                        rowCount = MaxCount,
                        status = "1" //1表示成功，0表示失败
                    }));
                    Response.End();    
               
            }
        }
    }
}