using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;
using Model;
using GiftCards = BLL.GiftCards;

namespace WebApp.PCenter
{
    public partial class MyGiftCardGet : PageBase.PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form["Action"] == "Get")
            {
                Response.ContentType = "application/json";
                try
                {
                    var giftbll = new BLL.GiftCards();
                    var result = 0;
                    giftbll.RechargeGiftCard(userAccount.Id, Request.Form["SN"].ToLower().Replace(" ", ""), "PC网站", userAccount.Compname,
                        1, out result);
                    if (result == 0)
                    {
                        Response.Write("{\"Message\":\"充值失败\"}");
                    }
                    else
                    {
                        Response.Write("{\"Message\":\"Complete\"}");
                    }
                }
                catch (Exception ex)
                {
                    LogHelper.WriteException(ex);
                    Response.Write("{\"Message\":\"" + ex.Message + "\"}");
                }
                finally
                {
                    Response.End();
                }
            }
        }
    }
}