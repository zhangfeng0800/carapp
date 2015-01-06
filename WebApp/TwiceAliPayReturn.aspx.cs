using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Com.Alipay;
using System.Collections.Specialized;
using BLL;
using IEZU.Log;

namespace WebApp
{
    public partial class TwiceAliPayReturn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            #region 处理部分

            SortedDictionary<string, string> sPara = GetRequestPost();
            if (sPara.Count > 0)
            {
                Notify aliNotify = new Notify();
                bool verifyResult = aliNotify.Verify(sPara, Request.Form["notify_id"], Request.Form["sign"]);
                if (verifyResult)
                {
                    string out_trade_no = Request.Form["out_trade_no"];
                    out_trade_no = out_trade_no.Split('_')[0];
                    string trade_no = Request.Form["trade_no"];
                    string trade_status = Request.Form["trade_status"];
                    DateTime gmt_payment = DateTime.Parse(Request.Form["gmt_payment"]);
                    string total_fee = Request.Form["total_fee"];
                    string body = Request.Form["body"].ToString();

                    if (Request.Form["trade_status"] == "WAIT_BUYER_PAY")
                    {
                        Response.Write("success");
                        Response.End();
                    }
                    else if (Request.Form["trade_status"] == "TRADE_FINISHED" ||
                             Request.Form["trade_status"] == "TRADE_SUCCESS")
                    {
                        int result = new BLL.AccountBLL().DealPayNotify(2, Common.Action.ALIPAY, out_trade_no,
                                                                        Convert.ToDecimal(total_fee));
                        
                    }

                    Response.Write("success");
                    Response.End();
                }
            }
            else
            {
                Response.Write("无通知参数");
                Response.End();
            }

            #endregion

        }

        public SortedDictionary<string, string> GetRequestPost()
        {
            int i = 0;
            SortedDictionary<string, string> sArray = new SortedDictionary<string, string>();
            NameValueCollection coll;
            coll = Request.Form;
            String[] requestItem = coll.AllKeys;
            for (i = 0; i < requestItem.Length; i++)
            {
                sArray.Add(requestItem[i], Request.Form[requestItem[i]]);
            }
            return sArray;
        }
    }
}