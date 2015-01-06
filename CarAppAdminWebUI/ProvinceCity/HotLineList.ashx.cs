using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.HSSF.Record.Chart;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// HotLineList 的摘要说明
    /// </summary>
    public class HotLineList : IHttpHandler
    {
        private readonly HotLineBLL _hotLineBll = new HotLineBLL();
        private readonly TravelthemeBll _travelthemeBll=new TravelthemeBll();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "tlist":
                    Tlist(context);
                    break;
            }
        }

        private void Tlist(HttpContext context)
        {
            var plist = _travelthemeBll.GetList();
            var list= plist.Select(m => new ComboTreeItem
            {
                id = m.Id.ToString(), text = m.Name, children = null
            }).ToList();
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void List(HttpContext context)
        {
            int count;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string provenceId = context.Request["provenceID"];
            string cityId = context.Request["cityID"];
            string townId = context.Request["townID"];
            string IsTravel = context.Request["IsTravel"]; //是否是景点

            string sort = context.Request["sort"] +" "+context.Request["order"];

            string where = "name like '%" + Common.Tool.SqlFilter(keyword) + "%'";
            if (!string.IsNullOrEmpty(provenceId))
            {
                where += " and provenceID='" + provenceId + "'";
            }
            if (!string.IsNullOrEmpty(cityId) && cityId != "0")
            {
                where += " and cityID='" + cityId + "'";
            }
            if (!string.IsNullOrEmpty(townId) && townId != "0")
            {
                where += " and countyId='" + townId + "'";
            }
            if (IsTravel != "-1")
            {
                where += " and istravel=" + IsTravel;
            }

            if (sort == " ")
            {   
                sort = " id desc ";
            }

            var list = _hotLineBll.GetPageList(pageIndex, pageSize,sort, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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