using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text.RegularExpressions;
using Com.Alipay;
using System.Collections.Generic;
using System.Collections.Specialized;
using System;
using BLL;
using Common;
using IEZU.Log;
using Model;
using DAL;
using System.IO;
using WebApp.PCenter.api;

namespace WebApp
{
    public partial class AliPayBgTransReturn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SortedDictionary<string, string> sPara = GetRequestPost();
            if (sPara.Count > 0)
            {
                Notify aliNotify = new Notify();
                bool verifyResult = aliNotify.Verify(sPara, Request.Form["notify_id"], Request.Form["sign"]);
                if (verifyResult)
                {
                    string out_trade_no = Request.Form["out_trade_no"];
                    string trade_no = Request.Form["trade_no"];
                    string trade_status = Request.Form["trade_status"];
                    DateTime gmt_payment = DateTime.Parse(Request.Form["gmt_payment"]);
                    string total_fee = Request.Form["total_fee"];
                    string body = Request.Form["body"].ToString();


                    if (trade_status == "WAIT_BUYER_PAY")
                    {
                        
                    }
                    else if (trade_status == "TRADE_FINISHED" || trade_status == "TRADE_SUCCESS")
                    {
                        if (body.Equals("order"))
                        {
                            int result = new BLL.AccountBLL().DealPayNotify(0, Common.Action.ALIPAY, out_trade_no,
                                                                            Convert.ToDecimal(total_fee));
                           　

                            Response.Write(result == 1 ? "success" : "fail");
                        }
                        else if (body.Equals("recharge"))
                        {
                            int result = new BLL.AccountBLL().DealPayNotify(1, Common.Action.ALIPAY, out_trade_no,
                                                                            Convert.ToDecimal(total_fee));
                            //Response.Write((new BLL.OrderBLL()).PayRecharge(out_trade_no, total_fee, trade_status, gmt_payment));
                        }


                        Response.Write("success");

                    }

                }
                else
                {
                    Response.Write("fail");
                }
            }
            else
            {
                Response.Write("无通知参数");
            }

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