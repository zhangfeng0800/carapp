using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// SaveHotLine 的摘要说明
    /// </summary>
    public class SaveHotLine : IHttpHandler
    {
        private readonly HotLineBLL _hotLineBll = new HotLineBLL();
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        private readonly TravelthemeBll _travelthemeBll=new TravelthemeBll();
        public void ProcessRequest(HttpContext context)
        {
            var message = new AjaxResultMessage();
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "add")
            {
                Add(context, ref message);
            }
            else if(action=="edit")
            {
                Edit(context, ref message);
            }
            else if (action == "delete")
            {
                Delete(context, ref message);
            }
            else if (action == "settheme")
            {
                SetTheme(context, ref message);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void SetTheme(HttpContext context, ref AjaxResultMessage message)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            string Linetheme = context.Request["Linetheme"];
            List<int> list = new List<int>();
            if (!string.IsNullOrEmpty(Linetheme))
            {
                Linetheme.Split(',').ToList().ForEach(c => list.Add(Convert.ToInt32(c)));
            }
            _travelthemeBll.DeleteLineTheme("lineid=" + id);
            
            list.ForEach(c => _travelthemeBll.AddLineTheme(id, c)); // todo:  循环访问数据库

            message.IsSuccess = true;
            message.Message = "";
        }

        private void Delete(HttpContext context, ref AjaxResultMessage message)
        {
            string idStr = context.Request["id"];
            int id;
            if (!int.TryParse(idStr, out id))
            {
                message.IsSuccess = false;
                message.Message = "参数无效";
            }
            else
            {
                _hotLineBll.Delete(id);
                _serviceCityBll.VirtualDelete("hotlineID=" + id);
                message.IsSuccess = true;
                message.Message = "";
            }  
        }

        private void Add(HttpContext context, ref AjaxResultMessage message)
        {
            string provenceID = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string name = context.Request["name"];
            string istravel = context.Request["istravel"];
            string price = context.Request["price"];
            string imgurl = context.Request["imgurl"];
            string simgurl = context.Request["simgurl"];
            string content = context.Request["content"]??"";
            string summary = context.Request["summary"];
            string sortorder = context.Request["sortorder"];
            int priceInt;
            if (_hotLineBll.IsExist(name))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此名称";
            }
            else if (!int.TryParse(price, out priceInt))
            {
                message.IsSuccess = false;
                message.Message = "输入的门票价格无效";
            }
            else
            {
                var model = new hotLine();
                model.cityID = cityId;
                model.provenceID = provenceID;
                model.countyId = countyId;
                model.name = name;
                model.ImgUrl = imgurl;
                model.SImgUrl = simgurl;
                model.Description = content;
                if (string.IsNullOrEmpty(istravel))
                {
                    model.IsTravel = 0;
                    model.Price = 0;
                }
                else
                {
                    model.IsTravel = 1;
                    model.Price = priceInt;
                }
                model.Summary = summary;
                model.SortOrder = string.IsNullOrEmpty(sortorder) ? 0 : Convert.ToInt32(sortorder);
                
                _hotLineBll.Add(model);

                message.IsSuccess = true;
                message.Message = "";
            }
        }

        private void Edit(HttpContext context, ref AjaxResultMessage message)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            string provenceId = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string name = context.Request["name"];
            string istravel = context.Request["istravel"];
            string price = context.Request["price"];
            string imgurl = context.Request["imgurl"];
            string simgurl = context.Request["simgurl"];
            string content = context.Request["content"]??"";
            string summary = context.Request["summary"];
            string sortorder = context.Request["sortorder"];
            int priceInt;
            if (_hotLineBll.IsExist(id,name))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此名称";
            }
            else if (!int.TryParse(price, out priceInt))
            {
                message.IsSuccess = false;
                message.Message = "输入的门票价格无效";
            }
            else
            {
                var model = new hotLine();
                model.id = id;
                model.cityID = cityId;
                model.provenceID = provenceId;
                model.countyId = countyId;
                model.name = name;
                model.ImgUrl = imgurl;
                model.SImgUrl = simgurl;
                model.Description = content;
                if (string.IsNullOrEmpty(istravel))
                {
                    model.IsTravel = 0;
                    model.Price = 0;
                }
                else
                {
                    model.IsTravel = 1;
                    model.Price = priceInt;
                }
                model.Summary = summary;
                model.SortOrder = string.IsNullOrEmpty(sortorder) ? 0 : Convert.ToInt32(sortorder);
                _hotLineBll.Update(model);
                message.IsSuccess = true;
                message.Message = "";
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