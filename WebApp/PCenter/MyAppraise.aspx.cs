using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyAppraise : PageBase.PageBase
    {
        public List<Model.Orders> orderList = new List<Model.Orders>();
        public int MaxCount = 0;
        public int totalPage = 0;
        public static int pageSize = 10;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["Remarked"] == null)
            {
                bool Remarked = Common.Tool.GetString(Request.QueryString["Remarked"]).ToLower() == "true" ? true : false;
                orderList = new BLL.OrderBLL().GetListByRemark(10, Common.Tool.GetInt(Request.QueryString["Previous"]), userAccount.Id, Remarked, out MaxCount);
                totalPage = Convert.ToInt32(Math.Ceiling(MaxCount / (double)pageSize));
            }
            else
            {
                bool Remarked = Common.Tool.GetString(Request["Remarked"]).ToLower() == "true" ? true : false;
                
                int pageIndex = Convert.ToInt32(Request["pageIndex"]);
                orderList = new BLL.OrderBLL().GetListByRemark(pageSize, pageSize * pageIndex, userAccount.Id, Remarked, out MaxCount);

                List<object> list = new List<object>();
                foreach (Model.Orders order in orderList)
                {
                    var model = new
                    {
                        orderId = order.orderId,
                        passengerName = order.passengerName,
                        caruseway = new BLL.CarUseWayBLL().GetUseName(new BLL.RentCarBLL().GetModel(order.rentCarID).carusewayID),
                        cartype = new BLL.CarTypeBLL().GetCarType(new BLL.RentCarBLL().GetModel(order.rentCarID).carTypeID),
                        departureTime = order.departureTime.ToString("yyyy-MM-dd HH:mm"),
                        orderDate = order.orderDate.ToString("yyyy-MM-dd HH:mm")
                    };
                    list.Add(model);
                }
                Response.Write(JsonConvert.SerializeObject(new
                {
                    data = list,
                    rowCount = MaxCount,
                    status = "1"//1代表成功 
                }));
                Response.End();
            }
        }
    }
}