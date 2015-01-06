using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// ChargeDescription 的摘要说明
    /// </summary>
    public class ChargeDescription : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "List":
                    List(context);
                    break;
                case "add":
                    AddData(context);
                    break;
                case "Delete":
                    Delete(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
            }
        }

        private void Edit(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["Id"]);
              string provinceId = context.Request["provinceId"];
            string cityId = context.Request["cityId"];
            string countyId = context.Request["countyId"];
            string Description = context.Request["Description"];
            string Sort = context.Request["Sort"];
            string State = context.Request["State"];

            Model.ChargeDescription charge = new BLL.ChargeDescriptionBll().GetModel(id);
            charge.ProvinceId = provinceId ?? "";
            charge.CityId = cityId ?? "";
            charge.TownId = countyId ?? "";
            charge.Description = Description;
            charge.Sort = Int32.Parse(Sort);
            charge.State = State;
            int result = new BLL.ChargeDescriptionBll().UpdateData(charge);
            context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = result }));

        }

        private void Delete(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            int result = new BLL.ChargeDescriptionBll().DelData(id);
            context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = result }));
        }

        private void AddData(HttpContext context)
        {
            string provinceId = context.Request["provinceId"];
            string cityId = context.Request["cityId"];
            string countyId = context.Request["countyId"];
            string Description = context.Request["Description"];
            string Sort = context.Request["Sort"];

            var model = new Model.ChargeDescription()
                        {
                            ProvinceId = provinceId,
                            CityId = cityId,
                            TownId = countyId,
                            Description = Description,
                            State = "显示",
                            Sort = Int32.Parse(Sort)
                        };
            int result = new BLL.ChargeDescriptionBll().AddData(model);

            context.Response.Write(JsonConvert.SerializeObject(new { IsSuccess = result }));
        }

        private void List(HttpContext context)
        {
            string provinceId = context.Request["provinceId"];
            string cityId = context.Request["cityId"];
            string countyId = context.Request["countyId"];
            string State = context.Request["State"];
            string where = " 1=1 ";
            if(!string.IsNullOrEmpty(provinceId))
            {
                where += " and ProvinceId = '" + provinceId + "'";
            }
            if (!string.IsNullOrEmpty(cityId))
            {
                where += " and CityId = '" + cityId + "'";
            }
            if (!string.IsNullOrEmpty(countyId))
            {
                where += " and TownId = '" + countyId + "'";
            }
            if (!string.IsNullOrEmpty(State))
            {
                where += " and State = '" + State + "'";
            }

            if(!string.IsNullOrEmpty(provinceId) &&string.IsNullOrEmpty(countyId))
            {
               
            }

            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
         
            int rowCount = 0;
            var chargeList = new BLL.ChargeDescriptionBll().GetPageList(pageSize, pageIndex, where, out rowCount);
            chargeList.ForEach(c=>
                                   {
                                       c.TownId = new BLL.CityBLL().GetFullAddressByCodeID(c.TownId); //todo:  循环访问数据库
                                   });

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = rowCount, rows = chargeList }));
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