using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;

namespace WebApp.api
{
    /// <summary>
    /// MyAppraise 的摘要说明
    /// </summary>
    public class MyAppraise : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            Routing(context, action);
        }
        public void Routing(HttpContext context, string action)
        {
            switch (action)
            {
                case "GetList": GetList(context); break;
                case "subRemark": submit(context); break;
                case "delete": delete(context); break;
                default:
                    break;
            }
        }

        public void GetList(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int currentPage = Convert.ToInt32(context.Request["currentPage"]);
            string statusType = context.Request["statusType"];
            int pageRowCount = 5;

            var result = SetOrderValue(userId).Where(s => s.orderStatusID == Convert.ToInt32(OrderStatus.订单完成)).ToList();
            string orderIds = "";
            foreach (var item in result)
            {
                orderIds += "'" + item.orderId + "'" + ",";
            }
            if (orderIds == "")
            {
                orderIds = "'-1'";
            }
            else
            {
                orderIds = orderIds.Substring(0, orderIds.Length - 1);
            }
            var remarksAppraised = new BLL.Remark().GetList(orderIds);
            List<Model.Orders> orderAppraised = GetAppraisedList(remarksAppraised, result);
            List<Model.Orders> orderNotAppraise = GetNotAppraiseList(remarksAppraised, result);
            int count = 0;
            int count2 = orderAppraised.Count;
            List<Model.Orders> result2 = new List<Model.Orders>();
            if (statusType == "appraised")
            {
                result2 = orderAppraised;
                count = orderAppraised.Count;
            }
            else if (statusType == "notAppraise")
            {
                result2 = orderNotAppraise;
                count = orderNotAppraise.Count;
            }
            int pageCount = count / 5;
            result2 = result2.Skip((currentPage - 1) * pageRowCount).Take(pageRowCount).ToList();
            string responseText = "";
            List<Model.CarUseWay> caruserways = BLL.CarUseWayBLL.getList();
            List<Model.CarType> cartypes = new BLL.CarTypeBLL().GetList();
            foreach (var item in result2)
            {
                string carUserWay = "";
                string carType = (from t in cartypes where t.id == item.rentCar.carTypeID select t.typeName).FirstOrDefault();
                carUserWay = (from c in caruserways where c.Id == item.rentCar.carusewayID select c.Name).FirstOrDefault();
                responseText += " <tr>";
                responseText += " <td>" + item.id + "</td>     ";
                responseText += " <td>" + item.passengerName + "</td>     ";
                responseText += " <td>" + carUserWay + "</td> ";
                responseText += " <td>" + carType + "</td> ";
                responseText += " <td>" + item.departureTime.ToString("yyyy-MM-dd HH:mm") + "</td> ";
                responseText += " <td>" + item.orderDate.ToString("yyyy-MM-dd HH:mm") + "</td> ";
                if (statusType == "appraised")
                {
                    responseText += " <td><a href='myremark.aspx?orderId=" + item.orderId + "'>修改</a><a href=\"javascript:Delete('" + item.orderId + "')\">删除</a></td> ";
                }
                else if (statusType == "notAppraise")
                {
                    responseText += " <td><a href='myremark.aspx?orderId=" + item.orderId + "'>评论</a></td> ";
                }
                responseText += "</tr>";
            }
            context.Response.Write(responseText + "|" + count + "|" + pageCount + "|" + count2);
        }
        public List<Model.Orders> SetOrderValue(int userid)
        {
            List<Model.Orders> orders = new List<Model.Orders>();
            Model.RentCar rentCars = new Model.RentCar();
            orders = BLL.OrderBLL.GetList(userid);
            foreach (var item in orders)
            {
                item.rentCar = new BLL.RentCarBLL().GetModel(item.rentCarID);
            }
            return orders;
        }
        public List<Model.Orders> GetNotAppraiseList(List<Model.Remark> appraisedRemarks, List<Model.Orders> totalOrders)
        {
            var resultModel = totalOrders;
            foreach (var item in appraisedRemarks)
            {
                Model.Orders resultOrder = (from r in resultModel where r.orderId == item.OrderId select r).FirstOrDefault();
                resultModel.Remove(resultOrder);
            }
            return resultModel;
        }
        public List<Model.Orders> GetAppraisedList(List<Model.Remark> appraisedRemarks, List<Model.Orders> totalOrders)
        {
            var resultModel = new List<Model.Orders>();
            foreach (var item in appraisedRemarks)
            {
                Model.Orders modelOrder = (from r in totalOrders where r.orderId == item.OrderId select r).FirstOrDefault();
                resultModel.Add(modelOrder);
            }
            return resultModel;
        }

        public void submit(HttpContext context)
        {
            string orderid = context.Request["orderid"];
            Model.Remark remark = new Model.Remark();
            Model.Remark checkRemark = new Model.Remark();
            var orderModel = new OrderBLL().GetModel(orderid);
            if (orderModel != null)
            {
                remark.JobNumber = orderModel.JobNumber;
                remark.Type = 1;
                remark.UserId = orderModel.userID;

            }
            remark.Content = context.Request["remarkContent"].Length > 200 ? context.Request["remarkContent"].Remove(200) : context.Request["remarkContent"];
            remark.OrderId = orderid;
            remark.Score = Convert.ToInt32(context.Request["score"]);
            checkRemark = new BLL.Remark().GetModel(orderid);
            remark.CreateTime = DateTime.Now;
            if (checkRemark == null)
            {
                new BLL.Remark().Add(remark);
                context.Response.Write("add");
            }
            else
            {
                new BLL.Remark().Update(remark);
                context.Response.Write("update");
            }
        }
        public void delete(HttpContext context)
        {
            string data = context.Request["datas"];
            new BLL.Remark().Delete(data);
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}