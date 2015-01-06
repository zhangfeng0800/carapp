using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.IO;
using System.Xml;
using System.Data.SqlClient;
using System.Text;

namespace WebApp.weixinService
{
    public partial class index : System.Web.UI.Page
    {
        private string Token = "aiyizuweixin"; //微信里面开发者模式Token
        private string appid = "wx2345420d88954ca7";//微信里面开发者模式：开发者，ID开发者凭据APPIDwx2345420d88954ca7
        private string appsecret = "87b870e88dbdbe8ec552ff79e40dc7a4";//微信里面开发者模式： 开发者密码 AppSecret
        public string AccessToken = ""; //获取的通行证

        protected void Page_Load(object sender, EventArgs e)
        {
            string postStr = "";

            //Valid();//校验签名,当填入的信息提交之后页面有提示“你已成功成为公众平台开发者，可以使用公众平台的开发功能”这个的时候，接下来你就需要注释掉这个校验的方法，使得后面的消息回复得以正常运作
            if (Request.HttpMethod.ToLower() == "post")//当普通微信用户向公众账号发消息时，微信服务器将POST该消息到填写的URL上
            {
                postStr = PostInput();
                if (string.IsNullOrEmpty(postStr) == false)
                {
                    //WriteLog(postStr,Server);//计入日记

                    //WriteLogDb("今天的啊"+postStr);
                    ResponseMsg(postStr);
                }
            }
        }
        private void Valid()
        {
            string echoStr = Request.QueryString["echoStr"].ToString();
            if (CheckSignature())
            {
                if (!string.IsNullOrEmpty(echoStr))
                {
                    Response.Write(echoStr);
                    Response.End();
                }
            }
        }

        /// <summary>
        /// 验证微信签名
        /// </summary>
        /// <returns></returns>
        private bool CheckSignature()
        {
            string signature = Request.QueryString["signature"].ToString();
            string timestamp = Request.QueryString["timestamp"].ToString();
            string nonce = Request.QueryString["nonce"].ToString();
            string[] ArrTmp = { Token, timestamp, nonce };
            Array.Sort(ArrTmp);//字典排序
            string tmpStr = string.Join("", ArrTmp);
            tmpStr = FormsAuthentication.HashPasswordForStoringInConfigFile(tmpStr, "SHA1");//对该字符串进行sha1加密
            tmpStr = tmpStr.ToLower();//对字符串中的字母部分进行小写转换，非字母字符不作处理
            //WriteLog(tmpStr, Server);//计入日志
            if (tmpStr == signature)//开发者获得加密后的字符串可与signature对比，标识该请求来源于微信。开发者通过检验signature对请求进行校验，若确认此次GET请求来自微信服务器，请原样返回echostr参数内容，则接入生效，否则接入失败
            {
                return true;
            }
            else
                return false;
        }

        /// <summary>
        /// 获取post返回来的数据
        /// </summary>
        /// <returns></returns>
        private string PostInput()
        {
            Stream s = System.Web.HttpContext.Current.Request.InputStream;
            byte[] b = new byte[s.Length];
            s.Read(b, 0, (int)s.Length);
            return Encoding.UTF8.GetString(b);
        }

        /// <summary>
        ///返回微信信息结果
        /// </summary>
        /// <param name="weixinXML"></param>
        private void ResponseMsg(string weixinXML)
        {
            try
            {
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(weixinXML);//读取XML字符串
                XmlElement rootElement = doc.DocumentElement;
                XmlNode MsgType = rootElement.SelectSingleNode("MsgType");//获取字符串中的消息类型
                string resxml = "";

                #region 分支一：处理文本消息
                if (MsgType.InnerText == "text")//如果消息类型为文本消息
                {
                    var model = new
                    {
                        ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                        FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                        CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                        MsgType = MsgType.InnerText,
                        Content = rootElement.SelectSingleNode("Content").InnerText,
                        MsgId = rootElement.SelectSingleNode("MsgId").InnerText
                    };
                    resxml += "<xml><ToUserName><![CDATA[" + model.FromUserName + "]]></ToUserName><FromUserName><![CDATA[" + model.ToUserName + "]]></FromUserName><CreateTime>" + ConvertDateTimeInt(DateTime.Now) + "</CreateTime>";
                    if (!string.IsNullOrEmpty(model.Content))//如果接收到消息
                    {
                        string replay = "";
                        if (model.Content.Contains("你好") || model.Content.Contains("好") || model.Content.Contains("hi") || model.Content.Contains("hello"))// 你好
                        {
                            replay = "你好，有事请留言，客服会及时回复你的。";
                        }
                        else if (model.Content.ToUpper().Contains("绑定ID")) //司机绑定微信的openId，格式如：  绑定ID+工号  如：绑定ID0010
                        {
                            var driverBll = new BLL.DirverAccountBLL();
                            string jobNumber = model.Content.Substring(4);
                            var driverModel = driverBll.GetModel(jobNumber);
                            if (driverModel == null)
                            {
                                replay = "对不起，工号不存在,注意输入格式：绑定ID+工号(加号不用输入)";
                            }
                            else
                            {
                                driverModel.OpenID = model.FromUserName;
                                int result = driverBll.Update(driverModel);
                                replay = result != 0 ? "恭喜，openID绑定成功" : "绑定失败，请联系技术人员";
                            }
                        }
                        else if (model.Content.ToUpper().Contains("BDYH"))//用户绑定微信openid
                        {
                            if(model.Content.Contains("#"))
                            {
                                string[] u = model.Content.Substring(4).Split('#');
                                string telephone = u[0];
                                string pwd = u[1];
                                var ubll = new BLL.UserAccountBLL();
                                var user = ubll.LoginByTelphone(telephone,pwd);
                                if (user == null)
                                    replay = "对不起，您输入的爱易租账号或密码错误,请重新输入";
                                    else
                                    {
                                        user.WeixinOpenId = model.FromUserName;
                                        ubll.UpdateUserAccount(user);
                                        replay = "恭喜，绑定成功";
                                    }
                                }
                            else
                            {
                                replay ="对不起，您输入的格式不正确，请重新输入。注意：不用输入+，账号和密码用#隔开";
                            }

                           
                        }
                        else
                        {
                            replay = "你好，更多信息请登陆我们的手机网站查看：http://m.iezu.cn 或者拨打客服电话: 0311-85119999";
                        }
                        resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[" + replay + "]]></Content></xml>";
                    }
                    else//没有接收到消息
                    {
                        resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[你好，更多信息请登陆我们的手机网站查看：http://m.iezu.cn 或者拨打客服电话: 0311-85119999]]></Content></xml>";
                    }

                    //WriteLogDb("##"+resxml);

                    Response.Write(resxml);
                } 
                #endregion

                #region 分支二：处理图片消息
                else if (MsgType.InnerText == "image")//如果消息类型为图片消息
                {
                    var model = new
                    {
                        ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                        FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                        CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                        MsgType = MsgType.InnerText,
                        PicUrl = rootElement.SelectSingleNode("PicUrl").InnerText,
                        MsgId = rootElement.SelectSingleNode("MsgId").InnerText
                    };
                    resxml += "<xml><ToUserName><![CDATA[" + model.FromUserName + "]]></ToUserName><FromUserName><![CDATA[" + model.ToUserName + "]]></FromUserName><CreateTime>" + ConvertDateTimeInt(DateTime.Now) + "</CreateTime><MsgType><![CDATA[news]]></MsgType><ArticleCount>1</ArticleCount><Articles><item><Title><![CDATA[欢迎您的光临！]]></Title><Description><![CDATA[非常感谢您的关注！]]></Description><PicUrl><![CDATA[http://...jpg]]></PicUrl><Url><![CDATA[http://www.baidu.com/]]></Url></item></Articles><FuncFlag>0</FuncFlag></xml>";
                    Response.Write(resxml);
                } 
                #endregion

                #region 分支三：处理事件消息
                else if (MsgType.InnerText == "event")
                {
                    string Event = rootElement.SelectSingleNode("Event").InnerText;

                    #region 用户订阅事件
                    if (Event == "subscribe")
                    {
                        var model = new
                        {
                            ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                            FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                            CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                            MsgType = MsgType.InnerText,
                            Event = rootElement.SelectSingleNode("Event").InnerText,
                        };
                        resxml += "<xml><ToUserName><![CDATA[" + model.FromUserName + "]]></ToUserName><FromUserName><![CDATA[" + model.ToUserName + "]]></FromUserName><CreateTime>" + ConvertDateTimeInt(DateTime.Now) + "</CreateTime>";

                        var list = new BLL.WxNewsBLL().GetModels("订阅", "");
                        if (list.Count > 0)
                        {
                            Model.WxNews news = list[0];
                            List<Model.WxNewsChildren> listch = new BLL.WxNewsBLL().GetList(news.ID);
                            resxml += "<MsgType><![CDATA[news]]></MsgType><ArticleCount>" + listch.Count + "</ArticleCount><Articles>";

                            for (int i = 0; i < listch.Count; i++)
                            {
                                resxml += "<item><Title><![CDATA[" + listch[i].Title + "]]></Title> <Description><![CDATA[" + listch[i].Description + "]]></Description><PicUrl><![CDATA[http://admin.iezu.cn" + listch[i].ImgUrl.Substring(2) + "]]></PicUrl><Url><![CDATA[" + listch[i].ContentUrl + "]]></Url></item>";
                            }
                            resxml += " </Articles></xml> ";
                            Response.Write(resxml);
                        }
                        else
                        {
                            resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[你好，有事请留言，客服会及时回复你]]></Content></xml>";
                            Response.Write(resxml);

                        }
                    } 
                    #endregion

                    #region 用户点击自定义按钮事件
                    else if (Event == "CLICK")
                    {
                        var model = new
                        {
                            ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                            FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                            CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                            MsgType = MsgType.InnerText,
                            Event = rootElement.SelectSingleNode("Event").InnerText,
                            EventKey = rootElement.SelectSingleNode("EventKey").InnerText,
                        };
                        resxml += "<xml><ToUserName><![CDATA[" + model.FromUserName + "]]></ToUserName><FromUserName><![CDATA[" + model.ToUserName + "]]></FromUserName><CreateTime>" + ConvertDateTimeInt(DateTime.Now) + "</CreateTime>";
                        if (model.EventKey == "iezulife_01")
                        {
                            var list = new BLL.WxNewsBLL().GetModels("租车生活", "发送中");
                            if (list.Count == 0)
                                list = new BLL.WxNewsBLL().GetToday("租车生活");
                            if (list.Count > 0)
                            {
                                Model.WxNews news = list[0];
                                List<Model.WxNewsChildren> listch = new BLL.WxNewsBLL().GetList(news.ID);
                                resxml += "<MsgType><![CDATA[news]]></MsgType><ArticleCount>" + listch.Count + "</ArticleCount><Articles>";

                                for (int i = 0; i < listch.Count; i++)
                                {
                                    resxml += "<item><Title><![CDATA[" + listch[i].Title + "]]></Title> <Description><![CDATA[" + listch[i].Description + "]]></Description><PicUrl><![CDATA[http://admin.iezu.cn" + listch[i].ImgUrl.Substring(2) + "]]></PicUrl><Url><![CDATA[" + listch[i].ContentUrl + "]]></Url></item>";
                                }
                                resxml += " </Articles></xml> ";
                                Response.Write(resxml);
                            }
                        }
                        else if (model.EventKey == "bindUesr")
                        {
                            resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[请输入如下格式：BDYH+爱易租账号+\"#\"+登录密码 来绑定您的爱易租账户，例如：BDYH155xxxxxxxx#123456]]></Content></xml>";
                            Response.Write(resxml);
                        }
                        else
                        {
                            resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[你好，有事请留言，客服会及时回复你]]></Content></xml>";
                            Response.Write(resxml);

                        }

                    } 
                    #endregion

                    #region 微信群发后推送信息MASSSENDJOBFINISH
                    else if (Event == "MASSSENDJOBFINISH") //微信群发后推送信息MASSSENDJOBFINISH
                    {
                        var model = new
                        {
                            ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                            FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                            CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                            MsgType = MsgType.InnerText,
                            Event = rootElement.SelectSingleNode("Event").InnerText,
                            MsgId = rootElement.SelectSingleNode("MsgId").InnerText,
                            Status = rootElement.SelectSingleNode("Status").InnerText,
                            TotalCount = rootElement.SelectSingleNode("TotalCount").InnerText,
                            FilterCount = rootElement.SelectSingleNode("FilterCount").InnerText,
                            SentCount = rootElement.SelectSingleNode("SentCount").InnerText,
                            ErrorCount = rootElement.SelectSingleNode("ErrorCount").InnerText
                        };
                        Model.WxNews wxnews = new BLL.WxNewsBLL().GetModelByMsgID(model.MsgId);
                        if (wxnews != null)
                        {
                            wxnews.State = model.Status;
                            wxnews.ReturnInfo = "共发送：" + model.TotalCount + " 条，其中发送成功：" + model.SentCount + " 条,发送失败" + model.ErrorCount + " 条";
                            new BLL.WxNewsBLL().UpdateData(wxnews);
                        }
                    } 
                    #endregion

                } 
                #endregion

                else//如果是其余的消息类型
                {
                    var model = new
                    {
                        ToUserName = rootElement.SelectSingleNode("ToUserName").InnerText,
                        FromUserName = rootElement.SelectSingleNode("FromUserName").InnerText,
                        CreateTime = rootElement.SelectSingleNode("CreateTime").InnerText,
                    };
                    resxml += "<xml><ToUserName><![CDATA[" + model.FromUserName + "]]></ToUserName><FromUserName><![CDATA[" + model.ToUserName + "]]></FromUserName><CreateTime>" + ConvertDateTimeInt(DateTime.Now) + "</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[亲，感谢您对我的关注，有事请留言，我会及时回复你的哦。]]></Content><FuncFlag>0</FuncFlag></xml>";
                    Response.Write(resxml);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Response.End();

        }

        /// <summary>
        /// datetime转换成unixtime
        /// </summary>
        /// <param name="time"></param>
        /// <returns></returns>
        private int ConvertDateTimeInt(System.DateTime time)
        {
            System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1));
            return (int)(time - startTime).TotalSeconds;
        }
    }
}