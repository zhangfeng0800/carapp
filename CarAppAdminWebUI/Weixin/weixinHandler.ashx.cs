using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CarAppAdminWebUI.App_Code;

namespace CarAppAdminWebUI.Weixin
{
    /// <summary>
    /// weixinHandler 的摘要说明
    /// </summary>
    public class weixinHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string action = context.Request["action"].ToString();
            switch (action)
            {
                case "getpid":
                    GetPselect(context);
                    break;
                case "add":
                    Add(context);
                    break;
                case "upweixin":
                    UploadWeixin(context);
                    break;
                case "del":
                    Delete(context);
                    break;
                case "update":
                    Update(context);
                    break;
                case "SendNews":
                    SendNews(context);
                    break;
            }


        }
        /// <summary>
        /// 得到所属父类列表
        /// </summary>
        public void GetPselect(HttpContext context)
        {
            if (context.Request.Form["pid"] == null)
            {
                context.Response.Write("0");
                return;
            }
            var data = new BLL.WxMenuBLL().GetList(Convert.ToInt32(context.Request.Form["pid"]));
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(data));
        }

        public void Add(HttpContext context)
        {
            if (context.Request["name"] == null)
            {
                context.Response.Write("0");
                return;
            }
            int pid = Convert.ToInt32(context.Request["pid"]);
            string name = context.Request["name"].ToString();
            string type = context.Request["type"].ToString();
            string url = context.Request["url"].ToString();

            int num = new BLL.WxMenuBLL().GetList(pid).Count;
            if (pid == 0) //一级菜单最多有3个
            {
                if (num >= 3)
                {
                    context.Response.Write("0");
                    return;
                }
            }
            else
            {
                if (num >= 5)//二级菜单最多5个
                {
                    context.Response.Write("0");
                    return;
                }
            }
            new BLL.WxMenuBLL().AddData(new Model.WxMenu() { Name = name, Pid = pid, Type = type, Url = url });
            context.Response.Write("1");
        }

        public void Delete(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            Model.WxMenu menu = new BLL.WxMenuBLL().GetModel(id);
            if (menu.Pid != 0)
            {
                context.Response.Write(new BLL.WxMenuBLL().DeleteData(id));
            }
            else
            {
                int num = new BLL.WxMenuBLL().DeleteData(id);
                int numc = new BLL.WxMenuBLL().DeleteByPid(id);
                if (num > numc)
                    context.Response.Write(num);
                else
                    context.Response.Write(numc);
            }
        }
        public void Update(HttpContext context)
        {
            if (context.Request["name"] == null)
            {
                context.Response.Write("0");
                return;
            }
            int id = Convert.ToInt32(context.Request["id"]);
            int pid = Convert.ToInt32(context.Request["pid"]);
            string name = context.Request["name"].ToString();
            string type = context.Request["type"].ToString();
            string url = context.Request["url"].ToString();

            try
            {
                Model.WxMenu menu = new BLL.WxMenuBLL().GetModel(id);
                menu.Name = name;
                menu.Pid = pid;
                menu.Type = type;
                menu.Url = url;

                int num = new BLL.WxMenuBLL().GetList(pid).Count;
                if (pid == 0) //一级菜单最多有3个
                {
                    if (num > 3)
                    {
                        context.Response.Write("0");
                        return;
                    }
                }
                else
                {
                    if (num > 5)//二级菜单最多5个
                    {
                        context.Response.Write("0");
                        return;
                    }
                }

                new BLL.WxMenuBLL().UpdateData(menu);
                context.Response.Write("1");
            }
            catch (Exception)
            {
                context.Response.Write("0");
            }

        }


        public void UploadWeixin(HttpContext context)
        {
            string postData = createMenuDate();
            string i = WXCommon.GetPage("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + WXCommon.Get_Access_token(), postData);
            context.Response.Write(i);
        }

        /// <summary>
        /// 高级群发接口 - 上传图文信息
        /// </summary>
        /// <param name="context"></param>
        public void SendNews(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["newID"]);

            var list = new BLL.WxNewsBLL().GetList(id);
            string postData = "{" + "\r\n";
            postData += "\"articles\":[ " + "\r\n";
            for (int i = 0; i < list.Count; i++)
            {
                postData += "{" + "\r\n";
                postData += "\"thumb_media_id\":\"" + list[i].Media_id + "\"," + "\r\n";
                postData += "\"author\":\"" + list[i].Author + "\"," + "\r\n";
                postData += "\"title\":\"" + list[i].Title + "\"," + "\r\n";
                postData += "\"content_source_url\":\"" + list[i].ContentUrl + "\"," + "\r\n";
                postData += "\"content\":\"" + list[i].Contentw + "\"," + "\r\n";
                postData += "\"digest\":\"" + list[i].Description + "\"" + "\r\n";
                if (i != list.Count - 1)
                    postData += "}," + "\r\n";
                else
                    postData += "}" + "\r\n";
            }
            postData += "]" + "\r\n";
            postData += "}" + "\r\n";
            string access_token = WXCommon.Get_Access_token();

            string response = WXCommon.GetPage("https://api.weixin.qq.com/cgi-bin/media/uploadnews?access_token=" + access_token, postData);
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            //转换成fileUp类
            fileUp amodel = js.Deserialize<fileUp>(response);//此处为定义的类，用以将json转成model    
            if (amodel.media_id == null)
            {
                context.Response.Write(0);
                return;
            }

            string result = WXCommon.GetPage("https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token=" + access_token, GetSendPost(amodel.media_id, access_token));
            erroModel erro = js.Deserialize<erroModel>(result);

            if (erro.errcode == "0")
            {
                Model.WxNews news = new BLL.WxNewsBLL().GetModel(id);
                news.State = "已发送";
                news.Media_id = amodel.media_id;
                news.ReturnInfo = erro.msg_id;
                news.SendTime = DateTime.Now;
                new BLL.WxNewsBLL().UpdateData(news);
            }

            context.Response.Write(erro.errcode);//成功时返回0
        }

        public string GetSendPost(string media_id, string acctoken)
        {
            string postData = "{";
            postData += "\"touser\":[\"";
            //postData += "\"ofp0xuJs4uAuYdJjRj3wepqafW6g\"";
            ////postData += "\"OPENID2\"";
            postData += WXCommon.GetOpenidList(acctoken);
            postData += "\"],";
            postData += "\"mpnews\":{";
            postData += "\"media_id\":\"" + media_id + "\"";
            postData += "},";
            postData += "\"msgtype\":\"mpnews\"";
            postData += "}";
            return postData;
        }


        /// <summary>
        /// 设置建立菜单项目
        /// 
        /// </summary>
        public string createMenuDate()
        {
            /* 目前自定义菜单最多包括3个一级菜单，每个一级菜单最多包含5个二级菜单。一级菜单最多4个汉字，二级菜单最多7个汉字，
             * 多出来的部分将会以“...”代替。请注意，创建自定义菜单后，由于微信客户端缓存，需要24小时微信客户端才会展现出来。
             * 建议测试时可以尝试取消关注公众账号后再次关注，则可以看到创建后的效果。目前自定义菜单接口可实现两种类型按钮，
             * 如下：click：用户点击click类型按钮后，微信服务器会通过消息接口推送消息类型为event	的结构给开发者
             * （参考消息接口指南），并且带上按钮中开发者填写的key值，开发者可以通过自定义的key值与用户进行交互；view：
             * 用户点击view类型按钮后，微信客户端将会打开开发者在按钮中填写的url值	（即网页链接），达到打开网页的目的，
             * 建议与网页授权获取用户基本信息接口结合，获得用户的登入个人信息。  */


            string postData = "{" + "\r\n";
            postData += "\"button\":[ " + "\r\n";

            var list = new BLL.WxMenuBLL().GetList(0);
            for (int i = 0; i < list.Count; i++)
            {
                var list2 = new BLL.WxMenuBLL().GetList(list[i].ID);

                postData += "{	" + "\r\n";

                if (list2.Count != 0) //包含子按钮
                {

                    postData += "\"name\":\"" + list[i].Name + "\"," + "\r\n";
                    postData += "\"sub_button\":[" + "\r\n";

                    for (int j = 0; j < list2.Count; j++)
                    {
                        postData += "{	" + "\r\n";
                        postData += "   \"type\":\"" + list2[j].Type + "\"," + "\r\n";
                        postData += "   \"name\":\"" + list2[j].Name + "\", " + "\r\n";
                        if (list2[j].Type == "view")
                            postData += "   \"url\":\"" + list2[j].Url + "\"" + "\r\n";
                        else
                            postData += "   \"key\":\"" + list2[j].Url + "\"" + "\r\n";
                        if (j == list2.Count - 1)
                            postData += "}]" + "\r\n";
                        else
                            postData += "}," + "\r\n";
                    }

                }
                else  //不包含子按钮
                {
                    postData += "\"type\":\"" + list[i].Type + "\"," + "\r\n";
                    postData += "\"name\":\"" + list[i].Name + "\"," + "\r\n";
                    if (list[i].Type == "view")
                        postData += "\"url\":\"" + list[i].Url + "\"" + "\r\n";
                    else
                        postData += "   \"key\":\"" + list[i].Url + "\"" + "\r\n";
                }

                if (i == list.Count - 1)
                    postData += "}]" + "\r\n";
                else
                    postData += "}," + "\r\n";
            }
            postData += "}" + "\r\n";

            return postData;
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