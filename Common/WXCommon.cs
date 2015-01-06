using System;
using System.Net;
using System.Web.Script.Serialization;
using System.Text;
using System.IO;
using System.Web.Configuration;
using System.Xml;
using Newtonsoft.Json;

namespace Common
{
    /// <summary>
    ///WXCommon 的摘要说明
    /// </summary>
    public static class WXCommon
    {
        public static string Token = "aiyizuweixin"; //微信里面开发者模式Token
        public static string appid = "wx2345420d88954ca7";//微信里面开发者模式：开发者，ID开发者凭据APPIDwx2345420d88954ca7
        public static string appsecret = "87b870e88dbdbe8ec552ff79e40dc7a4";//微信里面开发者模式： 开发者密码 AppSecret

        /// <summary>
        /// 获得access_token,获得通行证
        /// </summary>
        /// <param name="appid"></param>
        /// <param name="appsecret"></param>
        /// <returns></returns>
        public static string Get_Access_token()
        {
            try
            {
                string path = WebConfigurationManager.AppSettings["wxaccesstoken"].ToString();
                if (!File.Exists(@path)) //如果改目录下XML文件不存在，则新建一个xml文件
                {
                    XmlDocument doc = new XmlDocument();
                    XmlDeclaration dec = doc.CreateXmlDeclaration("1.0", "utf-8", null);
                    doc.AppendChild(dec);
                    //创建一个根节点（一级）
                    XmlElement root = doc.CreateElement("xml");
                    doc.AppendChild(root);
                    XmlNode node = doc.CreateElement("AccessToken");
                    node.InnerText = "";
                    root.AppendChild(node);
                    node = doc.CreateElement("AccessExpires");
                    node.InnerText = "2014-09-30 16:26:00";
                    root.AppendChild(node);
                    doc.Save(@path);
                }
                StreamReader str = new StreamReader(path, System.Text.Encoding.UTF8);
                XmlDocument xml = new XmlDocument();
                xml.Load(str);
                str.Close();
                str.Dispose();
                string MyToken = xml.SelectSingleNode("xml").SelectSingleNode("AccessToken").InnerText;
                DateTime AccessExpires = Convert.ToDateTime(xml.SelectSingleNode("xml").SelectSingleNode("AccessExpires").InnerText);
                if (DateTime.Now >= AccessExpires)
                {
                    var mode = Get_Access_tokenModel();
                    xml.SelectSingleNode("xml").SelectSingleNode("AccessToken").InnerText = mode.access_token;
                    DateTime _accessExpires = DateTime.Now.AddSeconds(int.Parse(mode.expires_in));
                    xml.SelectSingleNode("xml").SelectSingleNode("AccessExpires").InnerText = _accessExpires.ToString();
                    xml.Save(path);
                    MyToken = mode.access_token;
                }
                return MyToken;
            }
            catch (Exception)
            {
                return Get_Access_tokenModel().access_token;
            }

        }

        public static string Mytoken;
        public static DateTime MytokenExpires;
        public static string Get_Access_token11()
        {
            if (Mytoken == "" || MytokenExpires < DateTime.Now)
            {
                var mode = Get_Access_tokenModel();
                Mytoken = mode.access_token;
                MytokenExpires = DateTime.Now.AddSeconds(int.Parse(mode.expires_in));
            }
            return Mytoken;
        }

        public static accesstoken Get_Access_tokenModel()
        {
            WebClient webclient = new WebClient();
            string url = @"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + appsecret + "";
            byte[] bytes = webclient.DownloadData(url);//在指定的path上下载
            string result = Encoding.GetEncoding("utf-8").GetString(bytes);//转string
            JavaScriptSerializer js = new JavaScriptSerializer();
            //access_token类建立在本文档的最下面.
            accesstoken amodel = js.Deserialize<accesstoken>(result);//此处为定义的类，用以将json转成model       
            return amodel;
        }

        public static string GetOpenidList(string access_token)
        {
            WebClient webclient = new WebClient();

            string url = @"https://api.weixin.qq.com/cgi-bin/user/get?access_token=" + access_token;
            byte[] bytes = webclient.DownloadData(url);//在指定的path上下载
            string result = Encoding.GetEncoding("utf-8").GetString(bytes);//转string
            JavaScriptSerializer js = new JavaScriptSerializer();
            //access_token类建立在本文档的最下面.
            OpenID openmodel = js.Deserialize<OpenID>(result);//此处为定义的类，用以将json转成model       

            string rej = string.Join("\",\"", openmodel.data.openid);
            return rej;
        }

        /// <summary>
        /// 得到模板消息
        /// </summary>
        /// <returns></returns>
        public static string GetTempletPostData(string type, string openId, string Theme, string remark, string title = "")
        {
            var postData = "";
            if (type == "消息通知")
            {
                //消息通知模板
                //postData = "{" +
                //           "\"touser\":\"" + openId + "\"," +
                //           "\"template_id\":\"KLEZJewsEBXGrOA-bY9WekIf4AL2n-nQ0w96R0tcd-c\"," +
                //           "\"url\":\"\"," +
                //           "\"topcolor\":\"#FF0000\"," +
                //           "\"data\":{" +
                //           "\"first\": {" +
                //           "\"value\":\"" + title + "\"," +
                //           "\"color\":\"#173177\"" +
                //           "}," +
                //           "\"keyword1\":{" +
                //           "\"value\":\"" + title + "\"," +
                //           "\"color\":\"#173177\"" +
                //           "}," +
                //           "\"keyword2\":{" +
                //           "\"value\":\"" + DateTime.Now.ToString() + "\"," +
                //           "\"color\":\"#173177\"" +
                //           "}," +
                //           "\"remark\":{" +
                //           "\"value\":\"" + remark + "\"," +
                //           "\"color\":\"#173177\"" +
                //           "}" +
                //           "}" +
                //           "}";
                templete tem = new templete();
                tem.touser = openId;
                tem.template_id = "KLEZJewsEBXGrOA-bY9WekIf4AL2n-nQ0w96R0tcd-c";
                tem.url = "";
                tem.topcolor = "#FF0000";
                if (title == "")
                    title = Theme;
                else
                    title = "尊敬的" + title + "先生/女士";
                tem.data = new tempdata
                {
                    first = new content { value = title, color = "#000000" },
                    keyword1 = new content { value = Theme, color = "#ff0000" },
                    keyword2 = new content { value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), color = "#173177" },
                    remark = new content { value = remark, color = "#000000" }
                };
                postData = JsonConvert.SerializeObject(tem);
            }
            return postData;
        }
        /// <summary>
        /// 给司机推送微信消息
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="title"></param>
        /// <param name="remark"></param>
        /// <returns></returns>
        public static string SendMessageToDriver(string openId, string theme, string remark,string title = "")
        {
            return GetPage("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" + Get_Access_token(),
                    GetTempletPostData("消息通知", openId, theme, remark,title));
        }
        /// <summary>
        /// 订单确认成功
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        public static string SendConfirmMessageToUser(string openId,string typeName,string title = "")
        {
            return SendMessageToDriver(openId, "订单确认成功", "您的订单确认成功，您预订的是" + typeName + "车，调度中心正在紧急调配您预订的车辆，请耐心等待。客服电话：0311-85119999", title);
        }
        /// <summary>
        /// 派车成功的短信
        /// </summary>
        /// <param name="openId"></param>

        /// <param name="departureTime">出发时间</param>
        /// <param name="startAddress">上车地址</param>
        /// <returns></returns>
        public static string SendCarSuccess(string openId, DateTime departureTime, string startAddress,string carBrand,string username="")
        {
            var msg = string.Format("您预订的车辆已调配成功，预约时间：{0}；出发地点：{1}。车辆抵达后会以短信的形式通知您。客服热线（0311-85119999）", departureTime.ToString("yyyy-MM-dd HH:mm:ss"), startAddress);
            return SendMessageToDriver(openId, "派车通知", msg,username);
        }
        /// <summary>
        /// 司机已经出发的短信发给乘车人
        /// </summary>
        /// <param name="openId"></param>

        /// <param name="startAddress">上车地址</param>
        /// <param name="carNo">车牌号</param>
        /// <param name="driverName">司机姓名</param>
        /// <param name="carPhone">车辆电话</param>
        /// <returns></returns>
        public static string DriverStartToPassenger(string openId, string startAddress, string carNo, string driverName, string carPhone, string username = "")
        {
            var msg = string.Format("您预订的车辆现已出发，正开往{0}，请准备乘车，车牌号{1}，驾驶员{2}电话：{3}。客服电话：0311-85119999", startAddress, carNo, driverName,
                carPhone);
            return SendMessageToDriver(openId, "司机出发通知", msg,username);
        }
        /// <summary>
        /// 司机已经出发的短信发给下单人
        /// </summary>
        /// <param name="openId"></param>

        /// <param name="startAddress">上车地址</param>
        /// <param name="carNo">车牌号</param>
        /// <param name="driverName">司机姓名</param>
        /// <param name="carPhone">车辆电话</param>
        /// <param name="passengerName">乘客姓名</param>
        /// <returns></returns>
        public static string DriverStartToUser(string openId, string startAddress, string carNo, string driverName, string carPhone, string passengerName, string username = "")
        {
            var msg = string.Format("您预订的车辆现已出发，正开往{0}，请准备乘车，车牌号{1}，司机{2}师傅电话：{3}，请尽快通知乘车人{4}。客服电话：0311-85119999", startAddress, carNo,
                driverName,
                carPhone, passengerName);
            return SendMessageToDriver(openId, "司机出发通知", msg,username);
        }
        /// <summary>
        /// 司机就位发给乘车人
        /// </summary>
        /// <param name="openId"></param>

        /// <param name="carname">车辆名称</param>
        /// <param name="carNo">车牌号</param>
        /// <param name="driverName">司机名称</param>
        /// <param name="carPhone">车辆电话</param>
        /// <returns></returns>
        public static string DriverArriveToPassenger(string openId, string carname, string carNo, string driverName, string carPhone, string username = "")
        {
            var msg = string.Format("您预定的车辆{0}现已到达，车牌号:{1}，司机:{2}，司机电话:{3}。客服电话：0311-85119999", carname, carNo, driverName, carPhone);
            return SendMessageToDriver(openId, "司机就位通知", msg,username);
        }
        /// <summary>
        /// 司机就位发给下单人
        /// </summary>
        /// <param name="openId"></param>

        /// <param name="carname">车辆名称</param>
        /// <param name="carNo">车牌号</param>
        /// <param name="driverName">司机名称</param>
        /// <param name="carPhone">车辆电话</param>
        /// <param name="startAddress">上车地址</param>
        /// <param name="passengerName">乘车人姓名</param>
        /// <returns></returns>
        public static string DriverArriveToUser(string openId, string carname, string carNo, string startAddress, string driverName, string carPhone, string passengerName, string username = "")
        {
            var msg = string.Format("您预订的车辆已到达出发地点{2}，车辆为{0}车，牌照{1},请通知{3}，驾驶员{4}电话{5}。祝您乘车愉快！客服电话：0311-85119999", carname, carNo, startAddress, passengerName, driverName, carPhone);
            return SendMessageToDriver(openId, "司机就位通知", msg,username);
        }
        /// <summary>
        /// 二次付款通知
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="totalMinutes"></param>
        /// <param name="totalDistance"></param>
        /// <param name="overMinutes"></param>
        /// <param name="overDistance"></param>
        /// <param name="overMinutesFee"></param>
        /// <param name="overDistanceFee"></param>
        /// <param name="highwayFee"></param>
        /// <param name="parkFee"></param>
        /// <param name="airportFee"></param>
        /// <param name="emptyDistance"></param>
        /// <param name="emptyFee"></param>
        /// <param name="twiceFee"></param>
        /// <returns></returns>
        public static string TwicePayInfo(string openId, string totalMinutes, string totalDistance, string overMinutes, string overDistance, string overMinutesFee, string overDistanceFee, string highwayFee,
            string parkFee, string airportFee, string emptyDistance, string emptyFee, string endemptydistance,string endemptyfee,string twiceFee, string username = "")
        {
            var msg = string.Format("您的用车服务结束，共行驶{0}分钟{1}公里。根据套餐计费，超时{2}分钟，超里程{3}公里，需付超时费{4}元，超里程费{5}元，高速费{6}元，停车费{7}元，机场费{8}元，上车空驶里程{9}公里，上车空驶费{10}元，下车空驶里程{12}公里，下车空驶费{13}元，需二次付款{11}元。请登录爱易租个人中心完成二次付款。", totalMinutes, totalDistance, overMinutes, overDistance, overMinutesFee, overDistanceFee, highwayFee, parkFee, airportFee, emptyDistance, emptyFee, twiceFee, endemptydistance, endemptyfee);
            return SendMessageToDriver(openId, "二次付款通知", msg,username);
        }
        /// <summary>
        /// 二次付款完成的短信
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="payFee">二次付款的金额</param>
        /// <returns></returns>
        public static string TwicePaySuccess(string openId, string payFee, string username = "")
        {
            var msg = string.Format("支付成功，支付金额为{0}元，您预订的用车服务已完成，谢谢本次用车，期待再次为您服务。", payFee);
            return SendMessageToDriver(openId, "二次付款完成", msg, username);
        }
        /// <summary>
        /// 订单完成的短信
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="passengerName">乘车人姓名</param>
        /// <param name="carUseway">用车方式</param>
        /// <param name="startAddress">上车地址</param>
        /// <returns></returns>
        public static string OrderComplete(string openId, string passengerName, string carUseway, string startAddress,string username="")
        {
            var msg = string.Format("您预订的用车服务已完成，　乘车人{0}、用车方式{1}、出发地点{2}，谢谢本次用车，期待再次为您服务", passengerName, carUseway,
                startAddress);
            return SendMessageToDriver(openId, "用车服务已完成", msg,username);
        }
        /// <summary>
        /// 订单取消有退款
        /// </summary>
        /// <param name="openId"></param>
        /// <returns></returns>
        public static string CancelOrderWithMoney(string openId,string username="")
        {
            var msg = "您预订的用车服务已取消，支付订单的费用已退还至您的爱易租账户，期待下次为您服务。客服热线（0311-85119999）";
            return SendMessageToDriver(openId, "订单取消通知", msg,username);
        }
        /// <summary>
        /// 订单取消有扣款
        /// </summary>
        /// <param name="openId"></param>
        /// <returns></returns>
        public static string CancelOrder(string openId,string username="")
        {
            var msg = string.Format("您预订的用车服务已取消，根据服务规则，需扣除服务费用，如有订单余额将退还至您的爱易租账户，期待下次为您服务。客服热线（0311-85119999）");
            return SendMessageToDriver(openId, "订单取消通知", msg,username);
        }
        /// <summary>
        /// 司机到达时发给司机的短信
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="driverName">司机名称</param>
        /// <param name="passengerName">乘客名称</param>
        /// <param name="passengerPhone">乘客电话</param>
        /// <returns></returns>
        public static string ArriveToDriver(string openId, string driverName, string passengerName, string passengerPhone,string username="")
        {
            var msg = string.Format("{0}，我们已短信通知客户您已到达，乘车人：{1}，电话：{2}，若客户未按时上车，请联系客户", driverName, passengerName, passengerPhone);
            return SendMessageToDriver(openId, "司机到达通知", msg,username);
        }
        /// <summary>
        /// 订单完成发给司机的通知
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="driverName"></param>
        /// <param name="orderid"></param>
        /// <returns></returns>
        public static string OrderCompleteToDriver(string openId, string driverName, string orderid,string username="")
        {
            var msg = string.Format("尊敬的{0}，{1}号订单已成功完成。", driverName, orderid);
            return SendMessageToDriver(openId, "订单完成通知", msg,username);
        }
        /// <summary>
        /// 订单取消发给司机的通知
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="driverName"></param>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public static string OrderCancelToDriver(string openId, string driverName, string orderId,string username="")
        {
            var msg = string.Format("{0}，{1}号订单已取消。如有问题，请联系客服（0311-85119999）", driverName, orderId);
            return SendMessageToDriver(openId, "订单取消通知", msg,username);
        }
        /// <summary>
        /// 账户余额支付二次付款订单的通知
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="passengerName">乘客姓名</param>
        /// <param name="carUseway">用车方式</param>
        /// <param name="totalMney">订单总额</param>
        /// <param name="startAddress">上车地址</param>
        /// <param name="userBalance">账户余额</param>
        /// <returns></returns>
        public static string TwicePayWithBalance(string openId, string passengerName, string carUseway, string totalMney, string startAddress, string userBalance,string username="")
        {

            var msg = string.Format("您的用车服务结束，乘车人{0}、用车方式{1}、出发地点{2}，总支付费用{3}元，账户余额{4}元。详见爱易租个人中心，谢谢本次用车，期待再次为您服务。", passengerName, carUseway, startAddress, totalMney, userBalance);
            return SendMessageToDriver(openId, "二付款付成功", msg, username);
        }
        /// <summary>
        /// 使用支付宝等支付方式的二次付款
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="paymoney">支付金额</param>
        /// <param name="passengerName">乘客姓名</param>
        /// <param name="carUseway">用车方式</param>
        /// <param name="startAddress">上车地址</param>
        /// <returns></returns>
        public static string TwicePayWithPay(string openId, string paymoney, string passengerName, string carUseway, string startAddress,string username="")
        {
            var msg = string.Format("支付成功，支付金额为{0}元，您预订的用车服务已完成，乘车人{1}、用车方式{2}、预约上车地点{3}，谢谢本次用车，期待再次为您服务。", paymoney, passengerName, carUseway, startAddress);
            return SendMessageToDriver(openId, "二次付款成功", msg, username);
        }
        /// <summary>
        /// 车辆改派发给下单人
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="startTime"></param>
        /// <param name="startAddress"></param>
        /// <returns></returns>
        public static string ResentCarToUser(string openId, DateTime startTime, string startAddress,string username="")
        {
            var msg = string.Format("您预订的车辆已改派成功，预约时间：{0}；出发地点：{1}。车辆抵达后会以短信的形式通知您。客服热线（0311-85119999）",
                startTime.ToString("yyyy-MM-dd HH:mm:ss"), startAddress);
            return SendMessageToDriver(openId, "车辆改派成功", msg,username);
        }
        /// <summary>
        /// 车辆改派发给之前的司机
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="startTime"></param>
        /// <param name="startAddress"></param>
        /// <returns></returns>
        public static string ResentCarToDriver(string openId, DateTime startTime, string startAddress,string username="")
        {
            var msg = string.Format("预约出发时间为{0}，出发地点为{1}的订单已经改派，如有疑问请联系客服。客服热线（0311-85119999）", startTime.ToString("yyyy-MM-dd HH:mm:ss"), startAddress);
            return SendMessageToDriver(openId, "订单改派通知", msg,username);
        }
        /// <summary>
        /// 后台客服修改了订单信息，发送给用户的通知
        /// </summary>
        /// <param name="openId"></param>
        /// <param name="orderid"></param>
        /// <param name="startAddress"></param>
        /// <param name="arriveAddress"></param>
        /// <param name="startTime"></param>
        /// <param name="passengerName"></param>
        /// <param name="passengerPhone"></param>
        /// <returns></returns>
        public static string EditOrderInfo(string openId, string orderid, string startAddress, string arriveAddress, string startTime, string passengerName, string passengerPhone,string username="")
        {
            var msg = string.Format("修改订单信息成功：订单编号：{0}，上车地址：{1}，下车地址：{2}，出发时间：{3}，乘车人：{4}，乘车人电话：{5}", orderid, startAddress, arriveAddress, startTime, passengerName, passengerPhone);
            return SendMessageToDriver(openId, "订单修改通知", msg,username);
        }
        public static string SendMessageToDriver(string openId, string title, string remark, out string postData)
        {
            postData = GetTempletPostData("消息通知", openId, title, remark);
            return GetPage("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" + Get_Access_token(),
                  postData);
        }


        /// <summary>
        /// 根据地址获取信息
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string GetPage(string url)
        {
            string outdata = "";
            string token_url = url;

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



        /// <summary>
        /// 向微信端发送post请求
        /// </summary>
        /// <param name="posturl">请求地址</param>
        /// <param name="postData">请求内容</param>
        /// <returns></returns>
        public static string GetPage(string posturl, string postData)
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


    }

    public class templete
    {
        public string touser { get; set; }
        public string template_id { get; set; }
        public string url { get; set; }
        public string topcolor { get; set; }
        public tempdata data { get; set; }
    }
    public class tempdata
    {
        public content first { get; set; }
        public content keyword1 { get; set; }
        public content keyword2 { get; set; }
        public content remark { get; set; }
    }
    public class content
    {
        public string value { get; set; }
        public string color{ get; set; }
    }

    public class accesstoken
    {
        public string access_token { get; set; }
        public string expires_in { get; set; }
    }

    public class fileUp
    {
        public string type { get; set; }
        public string media_id { get; set; }
        public string created_at { get; set; }
    }

    public class erroModel
    {
        public string errcode { get; set; }
        public string errmsg { get; set; }
        public string msg_id { get; set; }
    }

    public struct data
    {
        public string[] openid;
    }
    public struct OpenID
    {
        public int total;
        public int count;
        public data data;
        public string next_openid;
    }

}