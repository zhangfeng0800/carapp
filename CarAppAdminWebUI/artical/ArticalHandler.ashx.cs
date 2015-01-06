using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using IEZU.Log;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.artical
{
    /// <summary>
    /// ArticalHandler 的摘要说明
    /// </summary>
    public class ArticalHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "getType":
                    GetType(context);
                    break;
                case "typelist":
                    Typelist(context);
                    break;
                case "addType":
                    addType(context);
                    break;
                case "updateType":
                    updateType(context);
                    break;
            }

        }

        private void updateType(HttpContext context)
        {
            try
            {
                string id = context.Request["typeID"];
                string name = context.Request["name"];
                int hasImage = Int32.Parse(context.Request["hasImage"]);
                int indexShow = Int32.Parse(context.Request["indexShow"]);
                int sort = 0;
                if (!string.IsNullOrEmpty(context.Request["sort"]))
                {
                    try
                    {
                        sort = Int32.Parse(context.Request["Sort"]);
                    }
                    catch (Exception exception)
                    {
                        context.Response.Write("请输入正确的排序");
                        LogHelper.WriteException(exception);
                        return;
                    }

                }
                if (name.Length > 40 || name.Length < 2)
                {
                    context.Response.Write("栏目名称2-40个汉字");
                    return;
                }
                Model.Artical artic = BLL.ArticalBLL.getArticalByID(Int32.Parse(id));
                artic.Name = name;
                artic.hasImage = hasImage;
                artic.indexShow = indexShow;
                artic.sort = sort;
                BLL.ArticalBLL.Update(artic);
                context.Response.Write(1);
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write("参数错误");
            }
        }

        private void addType(HttpContext context)
        {

            try
            {
                string name = context.Request["name"];
                int hasImage = Int32.Parse(context.Request["hasImage"]);
                int indexShow = Int32.Parse(context.Request["indexShow"]);
                int sort = 0;
                if (!string.IsNullOrEmpty(context.Request["sort"]))
                {
                    try
                    {
                        sort = Int32.Parse(context.Request["Sort"]);
                    }
                    catch (Exception exception)
                    {
                        context.Response.Write("请输入正确的排序");
                        LogHelper.WriteException(exception);
                        return;
                    }

                }
                if (name.Length > 40 || name.Length < 2)
                {
                    context.Response.Write("栏目名称2-40个汉字");
                    return;
                }

                var artical = new Model.Artical()
                {
                    Name = name,
                    hasImage = hasImage,
                    indexShow = indexShow,
                    sort = sort
                };
                BLL.ArticalBLL.Add(artical);
                context.Response.Write(1);
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write("操作失败");
            }

        }

        private void Typelist(HttpContext context)
        {
            List<Model.Artical> articals = BLL.ArticalBLL.GetArticalList();
            context.Response.Write(JsonConvert.SerializeObject(articals));
        }

        public void GetType(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["ID"]);
            Model.Artical arti = BLL.ArticalBLL.getArticalByID(id);
            string name = arti.Name;
            if (name != "")
                context.Response.Write(name);
        }

        public void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string title = context.Request["title"];
            string typeid = context.Request["typeid"];

            string where = " 1=1 ";
            if (!string.IsNullOrEmpty(typeid))
            {
                where += " and articalTypeID=" + typeid;
            }
            if (!string.IsNullOrEmpty(title))
            {
                where += " and  title like '%" + title + "%'";
            }
            var List = BLL.ArticalContent.GetPager(pageIndex, pageSize, where, out count);

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = List }));

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