using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using IEZU.Log;
using Model;
using System.Text;
using System.Web.Script.Serialization;

namespace CarAppAdminWebUI.Weixin
{
    public partial class NewsOpera : System.Web.UI.Page
    {
        public string state = "";
        public string type = "";
        public List<Model.WxNewsChildren> list;
        public int NewsID = 0;
        public string bottom = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            Model.ArticalContent content = BLL.ArticalContent.GetArticalContentByID(71);//得到手机底部文章
            if (content != null)
                bottom = content.contents;

            if (Request["action"] != null && Request["action"] != "")
            {
                string action = Request["action"].ToString();
                int clId = Int32.Parse(Request["clId"]);
                switch (action)
                {
                    case "edtiShow":
                        WxNewsChildren child = new WxNewsChildrenBLL().GetModel(clId);
                        StringBuilder sb = new StringBuilder();
                        //sb.Append("{\"ID\":\""+child.ID+"\",\"title\":\""+child.Title+"\",\"imgUrl\"}")
                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                        serializer.Serialize(child, sb);
                        Response.Write(sb.ToString());
                        Response.End();
                        break;
                    case "del":
                        new BLL.WxNewsChildrenBLL().DeleteData(clId);
                        Response.Write("1");
                        Response.End();
                        break;
                }
            }
            var sort = 0;
            if (!string.IsNullOrEmpty(Request["sort"]))
            {
                if (!int.TryParse(Request["sort"], out sort))
                {
                    sort = 0;
                }
            }
            if (sort < 0)
            {
                sort = 0;
            }
            try
            {
                if (Request.QueryString["wxNewsID"] != null)
                {
                    NewsID = Int32.Parse(Request.QueryString["wxNewsID"]);
                    //int newID = 1;
                    WxNews wxnews = new WxNewsBLL().GetModel(NewsID);
                    state = wxnews.State;
                    type = Request.QueryString["type"];
                    list = new WxNewsBLL().GetList(NewsID);
                }
                else
                {
                    int newsId = Convert.ToInt32(Request["NewsID"]);
                    string title = Request["title"].ToString();
                    string author = Request["author"].ToString();
                    string imgUrl = Request["imgUrl"].ToString();
                    string media_id = Request["media_id"].ToString();
                    string contentw = Request["contentw"].ToString();
                    contentw = Common.regexPath.DoChange(contentw, "http://admin.iezu.cn");
                    string description = Request["description"].ToString();
                    string type = Request["Type"].ToString();
                    string contentUrl = Request["contentUrl"].ToString();
                    int IsVis = 1;
                    if (string.IsNullOrEmpty(Request["isVis"]))
                    {
                        IsVis = 0;
                    }

                    WxNewsChildren wnc = new WxNewsChildren()
                    {
                        Author = author,
                        ContentUrl = contentUrl,
                        Contentw = contentw,
                        Description = description,
                        ImgUrl = imgUrl,
                        Media_id = media_id,
                        NewsId = newsId,
                        Title = title,
                        IsVisbottom = IsVis,
                        Sort = sort
                    };
                    int id = 0;
                    if (Request["ChildID"] != "")
                    {
                        id = Convert.ToInt32(Request["ChildID"]);
                        wnc.ID = id;
                        new WxNewsChildrenBLL().UpdateData(wnc);

                        //Response.Write("<script> alert('修改成功！');this.location.href='NewsOpera.aspx?wxNewsID=" + newsId + "'</script>");
                        Response.Redirect("NewsOpera.aspx?wxNewsID=" + newsId + "&type=" + type);
                    }
                    else
                    {
                        id = new WxNewsChildrenBLL().AddData(wnc);
                        if (contentUrl == "")
                        {
                            wnc.ContentUrl = "http://m.iezu.cn/carLifeWeixin.aspx?id=" + id;
                        }
                        wnc.ID = id;
                        new WxNewsChildrenBLL().UpdateData(wnc);
                        //Response.Write("<script> alert('添加成功！');this.location.href='NewsOpera.aspx?wxNewsID=" + newsId + "';</script>");
                        Response.Redirect("NewsOpera.aspx?wxNewsID=" + newsId + "&type=" + type);
                    }
                }
            }
            catch (Exception exp)
            {
                Response.Write(exp.Message);
                Response.End();
            }



        }
    }
}