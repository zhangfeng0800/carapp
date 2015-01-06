using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;

namespace WebApp
{
    public partial class recharge : System.Web.UI.Page
    {
        public string Username { get; set; }
        public int IsLogined { get; set; }
        protected bool IsRedirect { get; set; }
        protected Model.UserAccount userAccount = new Model.UserAccount();
        protected override void OnInit(EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                IsLogined = 0;
                Username = "游客";
            }
            else
            {
                userAccount = Session["UserInfo"] as Model.UserAccount;
                IsLogined = 1;
                Username = userAccount.Compname;
            }
            base.OnInit(e);
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Request.Form["txtRechargeId"] != null && Request.Form["userId"] != null)
                {
                    try
                    {
                        string rechargeId = Request.Form["txtRechargeId"];
                        var rechargebll = new rechargeBLL();
                        var data = rechargebll.GetRecharge(rechargeId);
                        if (data.Rows.Count == 0)
                        {
                            LogHelper.WriteOperation("充值订单号为" + rechargeId, OperationType.Query, "充值的订单号不存在", userAccount.Compname);
                            Response.Write("<script>alert('充值单号码不存在！')</script>");
                            return;

                        }
                        if (data.Rows[0]["rechargestatus"].ToString() == "1")
                        {
                            LogHelper.WriteOperation("充值订单号为" + rechargeId, OperationType.Query, "该充值单号码已经充值成功", userAccount.Compname);
                            Response.Write("<script>alert('该充值单号码已经充值成功，请重新下单！')</script>");
                            return;
                        }
                        addMo.Value = data.Rows[0]["rechargemoney"].ToString();
                        orderpay.Value = rechargeId;
                        rechargeNum.InnerText = rechargeId;
                        rechargeMoney.InnerText = data.Rows[0]["rechargemoney"].ToString() + "元";
                    }
                    catch (Exception ex)
                    {
                        IEZU.Log.LogHelper.WriteException(ex);
                    }
                }
                else
                {
                    Response.Redirect("/Default.aspx");
                }
            }


        }
    }
}