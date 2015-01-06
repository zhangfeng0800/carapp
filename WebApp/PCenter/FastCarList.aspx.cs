using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class FastCarList : PageBase.PageBase
    {
        protected List<Model.QuickOrderCar> orders = new List<Model.QuickOrderCar>();
        protected List<Model.Coupon> coupons = new List<Model.Coupon>();
        protected void Page_Load(object sender, EventArgs e)
        {
            orders = new BLL.QuickOrderCarBLL().GetList(userAccount.Id);
        }
    }
}