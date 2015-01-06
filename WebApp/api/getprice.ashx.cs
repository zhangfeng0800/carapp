using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getprice 的摘要说明
    /// </summary>
    public class getprice : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["rentcarid"] != null)
            {
                try
                {
                    var bll = new RentCarBLL();
                    var price = bll.GetPrice(int.Parse(context.Request.QueryString["rentcarid"]));
                    var model = bll.GetModel(int.Parse(context.Request.QueryString["rentcarid"]));
                    var typemodel = (new BLL.CarTypeBLL()).GeTable(model.carTypeID);
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        price = price,
                        num = typemodel.Rows[0]["passengernum"],
                        hotlineid = model.hotLineID,
                        FeeIncludes = model.feeIncludes,
                        StartPrice = model.DiscountPrice,
                        OriginPrice = model.startPrice
                    }));
                }
                catch
                {

                }

                //context.Response.Write((new RentCarBLL()).GetPrice(int.Parse(context.Request.QueryString["rentcarid"])));
            }
            else
            {
                context.Response.Write("0");
            }
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