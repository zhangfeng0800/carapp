using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.IO;
using System.Text;
using System.Xml;
using System.Data.SqlClient;

namespace WebApp
{
    public partial class weixin : System.Web.UI.Page
    {
        const string Token = "fangrun415";//定义一个局部变量不可以被修改，这里定义的变量要与接口配置信息中填写的Token一致
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

                    //WriteLogDb(postStr);
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
                            replay="你好，有事请留言，客服会及时回复你的。";
                        }
                        else
                        {
                            replay = "你好，更多信息请登陆我们的手机网站查看：http://m.iezu.cn 或者拨打客服电话: 0311-66009696";
                        }
                        
                        
                        resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[" + replay + "]]></Content></xml>";

                    }
                    else//没有接收到消息
                    {
                        resxml += "<MsgType><![CDATA[text]]></MsgType><Content><![CDATA[亲，感谢您对我的关注，有问题请留言。]]></Content></xml>";
                    }

                    //WriteLogDb("##"+resxml);

                    Response.Write(resxml);
                }
                if (MsgType.InnerText == "image")//如果消息类型为图片消息
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
        /// <summary>
        /// 写日志(用于跟踪)，可以将想打印出的内容计入一个文本文件里面，便于测试
        /// </summary>
        //public static void WriteLog(string strMemo, HttpServerUtility server)
        //{
        //    string filename = server.MapPath("/logs/log.txt");//在网站项目中建立一个文件夹命名logs（然后在文件夹中随便建立一个web页面文件，避免网站在发布到服务器之后看不到预定文件）
        //    if (!Directory.Exists(server.MapPath("//logs//")))
        //        Directory.CreateDirectory("//logs//");
        //    StreamWriter sr = null;
        //    try
        //    {
        //        if (!File.Exists(filename))
        //        {
        //            sr = File.CreateText(filename);
        //        }
        //        else
        //        {
        //            sr = File.AppendText(filename);
        //        }
        //        sr.WriteLine(strMemo);
        //    }
        //    catch
        //    {
        //    }
        //    finally
        //    {
        //        if (sr != null)
        //            sr.Close();
        //    }
        //}

        public static void WriteLogDb(string strMemo)
        {
            DBUtility.SqlDbHelper Helper = new DBUtility.SqlDbHelper();

            SqlParameter[] datas =
                {
                    new SqlParameter("@key","微信"),
                    new SqlParameter("@value",strMemo)
                };
            Helper.Insert("insert into test values(@key,@value)", datas);
        }


        
    }
}