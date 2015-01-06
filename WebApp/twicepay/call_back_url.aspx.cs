using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using Com;
using System.Data;
using System.Data.SqlClient;
using BLL;
namespace WebApp.twicepay
{
    public partial class call_back_url : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                Dictionary<string, string> sPara = GetRequestGet();
                if (sPara.Count > 0)
                {
                    Notify aliNotify = new Notify();
                    bool verifyResult = aliNotify.VerifyReturn(sPara, Request.QueryString["sign"]);
                    if (verifyResult)
                    {
                        string out_trade_no = Request.QueryString["out_trade_no"];
                        if (out_trade_no.Contains("_"))
                        {
                            out_trade_no = out_trade_no.Split('_')[0];
                        }
                        string trade_no = Request.QueryString["trade_no"];
                        string result = Request.QueryString["result"];
                        DataTable dt = new OrderBLL().GetOrderById(out_trade_no);
                        DataTable mem = new OrderBLL().GetMemByOrderId(out_trade_no);
                        payStatus.InnerText = "已付款";
                        totalFee.InnerText = dt.Rows[0]["totalMoney"].ToString() + "元";
                        member.InnerText = mem.Rows[0]["username"].ToString() + "（" + mem.Rows[0]["telphone"].ToString() + "）";
                        passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                    }
                    else
                    {
                        Response.Write("验证失败");
                    }
                }
                else
                {
                    Response.Write("无返回参数");
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
          
        }
        public Dictionary<string, string> GetRequestGet()
        {
            int i = 0;
            Dictionary<string, string> sArray = new Dictionary<string, string>();
            NameValueCollection coll;
            coll = Request.QueryString;
            String[] requestItem = coll.AllKeys;
            for (i = 0; i < requestItem.Length; i++)
            {
                sArray.Add(requestItem[i], Request.QueryString[requestItem[i]]);
            }
            return sArray;
        }
    }
}