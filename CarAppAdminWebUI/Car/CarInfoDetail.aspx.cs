using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;
using Model.Enume;

namespace CarAppAdminWebUI.Car
{
    public partial class CarInfoDetail : BasePage
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        protected Model.CarInfo CarInfoModel;
        public string WorkStatus = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string idStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idStr))
            {
                GoErrorPage();
            }
            else
            {
                CarInfoModel = _carInfoBll.GetModel(idStr);
                if (CarInfoModel == null)
                {
                    GoErrorPage();
                }

            }
        }

        public string GetWorkStatus(CarWorkStatus status)
        {
            switch (status)
            {
                case CarWorkStatus.AlreadyInPlace:
                    return "已经就位";
                case CarWorkStatus.Others:
                    return "其它";
                case CarWorkStatus.canOrder:
                    return "可以接单/空闲中";
                case CarWorkStatus.hasBeenSetOut:
                    return "已出发";
                case CarWorkStatus.leave:
                    return " 离开或请假";
                case CarWorkStatus.orderPickedUp:
                    return "订单已接取";
                case CarWorkStatus.working:
                    return "工作中";
                default:
                    return "";
            }

        }
    }
}