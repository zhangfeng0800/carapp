using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using Com.Alipay;
using com.yeepay;
using System.Data;
using System.Data.SqlClient;
using Common;
using Model;
using BLL;
namespace WebApp
{
    public partial class OrderPaySuccess : System.Web.UI.Page
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
                Username = userAccount.Username;
            }
            base.OnInit(e);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    SortedDictionary<string, string> sPara = GetRequestGet();
                    if (sPara.Count > 0)
                    {
                        HandleAliPay(sPara);
                    }
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
         
        }
        public SortedDictionary<string, string> GetRequestGet()
        {
            int i = 0;
            SortedDictionary<string, string> sArray = new SortedDictionary<string, string>();
            NameValueCollection coll;
            coll = Request.QueryString;
            String[] requestItem = coll.AllKeys;
            for (i = 0; i < requestItem.Length; i++)
            {
                sArray.Add(requestItem[i], Request.QueryString[requestItem[i]]);
            }
            return sArray;
        }
        private void HandleAliPay(SortedDictionary<string, string> sPara)
        {
            Notify aliNotify = new Notify();
            bool verifyResult = aliNotify.Verify(sPara, Request.QueryString["notify_id"], Request.QueryString["sign"]);
            if (verifyResult)
            {
                string out_trade_no = Request.QueryString["out_trade_no"].ToString();
                string trade_no = Request.QueryString["trade_no"].ToString();
                string sign_type = Request.QueryString["sign_type"].ToString();
                string body = Request.QueryString["body"].ToString();
                if (body.Equals("order"))
                {
                    tip.InnerText = "恭喜您，订单支付成功！";
                    orderTip.InnerText = "感谢您选择爱易租用车服务，调配中心正在调配您预订的车辆，请稍后";
                    payType.InnerText = "您的订单号是：";
                    orderNum.InnerText = out_trade_no;
                    memCenter.InnerText = "您可以登录个人中心查看订单、账户余额与流水详情";
                }
                else if (body.Equals("recharge"))
                {
                    tip.InnerText = "恭喜您，充值成功！";
                    orderTip.InnerText = "感谢您选择爱易租用车服务，更多充值，更多惊喜";
                    payType.InnerText = "您的充值单号是：";
                    orderNum.InnerText = out_trade_no;
                    memCenter.InnerText = "您可以登录个人中心查看充值、账户余额与流水详情";
                }
            }
            else
            {
                Response.Write("验证失败了！");
                Response.End();
            }
        }
    }
}