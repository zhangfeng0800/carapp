using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebApp.PCenter
{

    public partial class MyGiftCard : PageBase.PageBase
    {
        protected int giftCount = 0;
        protected int totalPage = 0;
        protected List<Model.GiftCards> giftCards = new List<Model.GiftCards>();
        protected void Page_Load(object sender, EventArgs e)
        {
            int pageSize = 5;
            if (Request.Form["pageIndex"] != null)
            {
                giftCards = new BLL.GiftCards().GetList(Convert.ToInt32(Request.Form["pageIndex"]), pageSize, " userID=" + userAccount.Id, out giftCount);
                Response.Write(JsonConvert.SerializeObject(new
                {
                    data = giftCards,
                    rowCount = giftCount,
                    status = "1" //1表示成功，0表示失败
                }));
                Response.End();
            }
            else
            {
                giftCards = new BLL.GiftCards().GetList(1, pageSize, " userID=" + userAccount.Id, out giftCount);
                totalPage = Convert.ToInt32(Math.Ceiling(giftCount / (double)pageSize));
            }
        }
    }
}