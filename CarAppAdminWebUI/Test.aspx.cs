using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.App_Code;
using Model;

namespace CarAppAdminWebUI
{
    public partial class Test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CarInfoBLL bll=new CarInfoBLL();
            bll.GetCarGpsData();
           // GPSOperation.ExportGpsData();


            //var token = WXCommon.Get_Access_token();

            //string s = WXCommon.GetOpenidList(token);

            //string[] arry = s.Split(',');

            //foreach (var s1 in arry)
            //{
            //    var openid = s1.Replace("\\", "").Replace('"', ' ').Trim();
            //    var zhang =
            //   WXCommon.GetData("https://api.weixin.qq.com/cgi-bin/user/info?access_token=" +
            //                   token + "&openid=" + openid + "&lang=zh_CN");
            //    if(zhang.Contains("张利锋"))
            //    {
            //        int a = 2;
            //        int v = 2;
            //        int f = 2;
            //        int z = 2;
            //        int x = 2;
            //    }
            //}


            //var url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" +
            //          WXCommon.Get_Access_token();

            //var postData = "{" +
            //               "\"touser\":\"ofp0xuJs4uAuYdJjRj3wepqafW6g\"," +
            //               "\"template_id\":\"OY-evG3uVmGHXo9EfY01z6xzx64W0176zlidXnxjcuI\"," +
            //               "\"url\":\"\"," +
            //               "\"topcolor\":\"#FF0000\"," +
            //               "\"data\":{" +
            //                               "\"first\": {" +
            //                               "\"value\":\"您的用车服务已结束\"," +
            //                               "\"color\":\"#173177\"" +
            //                               "}," +
            //                               "\"svrdate\":{" +
            //                               "\"value\":\""+DateTime.Now.ToString()+"\"," +
            //                               "\"color\":\"#173177\"" +
            //                               "}," +
            //                               "\"dealername\":{" +
            //                               "\"value\":\"河北方润汽车租赁有限公司\"," +
            //                               "\"color\":\"#173177\"" +
            //                               "}," +
            //                               "\"svrproject\":{" +
            //                               "\"value\":\"派车成功\"," +
            //                               "\"color\":\"#173177\"" +
            //                               "}," +
            //                               "\"remark\":{" +
            //                               "\"value\":\"已为用户派车，联系人：张峰峰，联系电话：18544554\"," +
            //                               "\"color\":\"#173177\"" +
            //                               "}" +
            //                       "}" +
            //               "}";

            //string result = WXCommon.GetPage(url, postData);

        }
    }
}