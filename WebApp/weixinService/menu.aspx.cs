using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Xml;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Net;
using System.Web.Script.Serialization;
namespace WebApp.weixinService
{
    public partial class weixin_menu : System.Web.UI.Page
    {
        private string Token = "aiyizuweixin"; //微信里面开发者模式Token
        private string appid = "wx2345420d88954ca7";//微信里面开发者模式：开发者，ID开发者凭据APPIDwx2345420d88954ca7
        private string appsecret = "87b870e88dbdbe8ec552ff79e40dc7a4";//微信里面开发者模式： 开发者密码 AppSecret
        public string AccessToken = ""; //获取的通行证
        protected void Page_Load(object sender, EventArgs e)
        {

            //setMenu();//建立菜单
            //this.Label1.Text = Get_Access_token(appid, appsecret);//获取AccessToken

            GetAllOpenID();

        }
        /// <summary>
        /// 获得access_token,获得通行证
        /// </summary>
        /// <param name="appid"></param>
        /// <param name="appsecret"></param>
        /// <returns></returns>
        public string Get_Access_token(string appid, string appsecret)
        {
            WebClient webclient = new WebClient();
            
            string url = @"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + appsecret + "";
            byte[] bytes = webclient.DownloadData(url);//在指定的path上下载
            string result = Encoding.GetEncoding("utf-8").GetString(bytes);//转string
            JavaScriptSerializer js = new JavaScriptSerializer();
            //access_token类建立在本文档的最下面.
            accesstoken amodel = js.Deserialize<accesstoken>(result);//此处为定义的类，用以将json转成model        
            string a_token = amodel.access_token;
            return a_token;
        }
        /// <summary>
        /// 设置建立菜单
        /// </summary>
        public void setMenu()
        {
            string i = GetPage("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + Get_Access_token(appid, appsecret), createMenuDate());
            Response.Write(i);
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
            postData += "{	" + "\r\n";
            postData += "\"name\":\"在线订车\"," + "\r\n";
            postData += "\"sub_button\":[" + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"热门线路\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_001001\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"接送机\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_001002\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"半日/日租\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_001003\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"特别推荐\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_001002\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"会议租车\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_001004\"" + "\r\n";
            postData += " }]" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{" + "\r\n";
            postData += "\"name\":\"优惠活动\", " + "\r\n";
            postData += "\"sub_button\":[" + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"优惠券\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_002001\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"抽奖\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"click\"," + "\r\n";
            postData += "   \"name\":\"刮刮卡\", " + "\r\n";
            postData += "   \"key\":\"gtt_menu_002003\"" + "\r\n";
            postData += " }]" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{" + "\r\n";
            postData += "\"name\":\"我的账户\"," + "\r\n";
            postData += "\"sub_button\":[" + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"我的订单\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"我的积分\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"在线充值\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"账户余额\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += "}," + "\r\n";
            postData += "{	" + "\r\n";
            postData += "   \"type\":\"view\"," + "\r\n";
            postData += "   \"name\":\"留言反馈\", " + "\r\n";
            postData += "   \"url\":\"http://www.iezu.cn\"" + "\r\n";
            postData += " }]" + "\r\n";
            postData += "}]" + "\r\n";
            postData += "}" + "\r\n";

            return postData;
        }

        public string GetPage(string posturl, string postData)
        {
            Stream outstream = null;
            Stream instream = null;
            StreamReader sr = null;
            HttpWebResponse response = null;
            HttpWebRequest request = null;
            Encoding encoding = Encoding.UTF8;
            byte[] data = encoding.GetBytes(postData);
            // 准备请求...
            try
            {
                // 设置参数
                request = WebRequest.Create(posturl) as HttpWebRequest;
                CookieContainer cookieContainer = new CookieContainer();
                request.CookieContainer = cookieContainer;
                request.AllowAutoRedirect = true;
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;
                outstream = request.GetRequestStream();
                outstream.Write(data, 0, data.Length);
                outstream.Close();
                //发送请求并获取相应回应数据
                response = request.GetResponse() as HttpWebResponse;
                //直到request.GetResponse()程序才开始向目标网页发送Post请求
                instream = response.GetResponseStream();
                sr = new StreamReader(instream, encoding);
                //返回结果网页（html）代码
                string content = sr.ReadToEnd();
                string err = string.Empty;
                return content;
            }
            catch (Exception ex)
            {
                string err = ex.Message;
                return string.Empty;
            }
        }

        public string GetAllOpenID()
        {
            string outdata = "";
            string token_url = "https://api.weixin.qq.com/cgi-bin/user/get?access_token=" + Get_Access_token(appid, appsecret) + "&next_openid=";

            HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(token_url);
            myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
            myHttpWebRequest.Method = "get";
            myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
            Stream myResponseStream = myHttpWebResponse.GetResponseStream();
            StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
            outdata = myStreamReader.ReadToEnd();
            myStreamReader.Close();
            myResponseStream.Close();
            return outdata;
        }

        public class accesstoken
        {
            public string access_token { get; set; }
            public string expires_in { get; set; }

            //private string access_token1;
            //public string accesstoken
            //{
            //    get { return access_token1; }
            //    set { access_token1 = value; }
            //}
            //private int expires_in;
            //public int expiresin
            //{
            //    get { return expires_in; }
            //    set { expires_in = value; }
            //} 
        }


    }
}