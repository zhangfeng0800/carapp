using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;
using IEZU.Log.LogDAL;
using System.Xml;
using System.Text;
using System.Security.Cryptography;
using System.Net;
using System.Collections.Specialized;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Data.Common;

namespace WebApp
{
    public partial class Test : System.Web.UI.Page
    {
        public static String userName = "dh22040";  //用户名，如：dh123 
        public static String password = "WA4?b%tp"; //密码，如：dh.123 
    
        public static String sign="【爱易租】";    //短信签名，签名 
        public static String subcode = "";  //子号码，可为空 
        public static String msgid = "";    //短信 id，查询短信状态报告时需要，可为空 
        public static String sendtime="";    //定时发送时间，时间格式201305051230
        public static String url = "http://3tong.net/http/sms/Submit"; //无限通地址

        protected void Page_Load(object sender, EventArgs e)
        {
            var Winddt = new BLL.OrderBLL().GetPassengerList("2014121713500313551", "已付款", 451);
            var windUn = new BLL.OrderBLL().GetPassengerList("2014121713500313551", "已取消", 451);
            foreach (DataRow row in windUn.Rows)
            {
                DataRow newrow = Winddt.NewRow();
                newrow.ItemArray = row.ItemArray;
                Winddt.Rows.Add(newrow);
            }
        }

        public static string Post(string URL, string message)
        {
            WebClient webClient = new WebClient();
            NameValueCollection postValues = new NameValueCollection();
            postValues.Add("message", message);

            //向服务器发送POST数据
            byte[] responseArray = webClient.UploadValues(URL, postValues);
            return Encoding.UTF8.GetString(responseArray);
        }

        //封装xml
        private static string DocXml(string account, string password, string msgid, string phones, string content, string subcode, string sendtime, string sign)
        {
            XmlDocument doc = new XmlDocument();
            XmlNode xmlnode = doc.CreateXmlDeclaration("1.0", "utf-8", null);
            doc.AppendChild(xmlnode);
            XmlElement xe1 = doc.CreateElement("response");
            XmlElement sub1 = doc.CreateElement("account");
            sub1.InnerText = account;
            xe1.AppendChild(sub1);
            XmlElement sub2 = doc.CreateElement("password");
            sub2.InnerText = md5(password);
            xe1.AppendChild(sub2);
            XmlElement sub3 = doc.CreateElement("msgid");
            sub3.InnerText = msgid;
            xe1.AppendChild(sub3);
            XmlElement sub4 = doc.CreateElement("phones");
            sub4.InnerText = phones;
            xe1.AppendChild(sub4);
            XmlElement sub5 = doc.CreateElement("content");
            sub5.InnerText = content;
            xe1.AppendChild(sub5);
            XmlElement sub6 = doc.CreateElement("subcode");
            sub6.InnerText = subcode;
            xe1.AppendChild(sub6);
            XmlElement sub7 = doc.CreateElement("sendtime");
            sub7.InnerText = sendtime;
            xe1.AppendChild(sub7);
            XmlElement sub8 = doc.CreateElement("sign");
            sub8.InnerText = sign;
            xe1.AppendChild(sub8);
            doc.AppendChild(xe1);
            return xe1.OuterXml;
        }
        //MD5加密程序（32位小写）
        private static string md5(string str)
        {
            byte[] result = Encoding.Default.GetBytes(str);
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] output = md5.ComputeHash(result);
            String md = BitConverter.ToString(output).Replace("-", "");
            return md.ToLower();
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string data = Post(url, DocXml(userName, password, msgid, txtPhone.Text, txtContent.Text, subcode, sendtime, sign));
           

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data);
            string result = doc.SelectSingleNode("response/result").InnerText;

            lblMsgid.Text = data + "结果：" + result + " 提示：" + doc.SelectSingleNode("response/desc").InnerText; 

            lblResult.Text = "";
            LogHelper.WriteOperation(result, OperationType.Add, "大汉三通短信", "");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            String message = "<?xml version='1.0' encoding='UTF-8'?><message>"
                    + "<account>" + userName + "</account>" + "<password>"
                    + md5(password) + "</password>"
                    + "<msgid>" + txtMsgid.Text + "</msgid><phone>" + txtPhone.Text + "</phone></message>";
            string result = Post("http://3tong.net/http/sms/Report", message);

            lblResult.Text = result;
            
        }

    }
}

