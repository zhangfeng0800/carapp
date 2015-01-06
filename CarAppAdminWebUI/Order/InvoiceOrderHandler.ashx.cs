using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using BLL;
using Common;
using Model;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Order
{
    /// <summary>
    /// InvoiceOrderHandler 的摘要说明
    /// </summary>
    public class InvoiceOrderHandler : IHttpHandler
    {
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly OrderInvoiceBll _invoiceBll=new OrderInvoiceBll();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "setMail":
                    SetMail(context);
                    break;
            }
        }




        private void SetMail(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            var model = _orderBll.GetModel(id);
            if (model == null)
            {
                message.IsSuccess = false;
                message.Message = "数据错误";
            }
            else
            {
                if(model.invoiceStatus == 1) //0未邮寄， 1已邮寄， 2已取消
                {
                    message.IsSuccess = false;
                    message.Message = "改发票已经设为已邮寄状态，不能重复设置";
                }
                else
                {
                    var invoiceModel = _invoiceBll.GetModel(model.orderId);
                    if (invoiceModel == null)
                    {
                        message.IsSuccess = false;
                        message.Message = "无效的发票信息";
                    }
                    else
                    {
                        _invoiceBll.UpdateInvoiceState(model.orderId);
                        _orderBll.UpdateinvoiceStatus(id);

                        Common.SMS.user_InvoicePosted(model.passengerName, model.orderId, invoiceModel.InvoiceAdress, model.passengerPhone);
                        //string content = model.passengerName + "," + model.orderId + "," + invoiceModel.InvoiceAdress;
                       
                        //Common.SMS.MessageSender(content, model.passengerPhone, Common.SMSTemp.UserInvoicePosted);
                    }
                    message.IsSuccess = true;
                    message.Message = "";
                }
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string orderid = context.Request["orderid"]??"";
            int invoiceStatus = string.IsNullOrEmpty(context.Request["invoiceStatus"])?0:Convert.ToInt32(context.Request["invoiceStatus"]);
            string where = "";// "(invoiceStatus is null or invoiceStatus=0) and isreceipts is not null and isreceipts!=0 and orderStatusID=6";
          
           
            //  var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count);
            //var data = _orderBll.GetOrderInvoicePage(where, pageSize, pageIndex, out count);

            var data = new BLL.OrderInvoiceBll().GetOrderInvoicePage(invoiceStatus, 0, 6, orderid, pageSize, pageIndex,
                                                                     out count);
            context.Response.Write(JsonConvert.SerializeObject(new {index = pageIndex, total = count, rows = data}));
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