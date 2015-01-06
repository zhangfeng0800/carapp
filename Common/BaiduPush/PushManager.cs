using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.BaiduPush.Enums;

namespace Common.BaiduPush
{
    public static class PushManager
    {
        static readonly string sk;
        static readonly string ak;
        private static readonly string clientsk;
        private static readonly string clientak;
        static PushManager()
        {
            sk = "KSidqpevGzjsFRmP4KKMg65GScjrUzPh";
            ak = "o1tCtcLSm5bCUGQAfZs6y8Qg";
            clientsk = "XS9VTHoWEfGOSGoOI6ED6GTzfGaW2yOQ";
            clientak = "jSxtkPPNW30njNWMM0MsGvXf";
        }

        /// <summary>
        /// 百度云推送通知
        /// </summary>
        /// <param name="deviceType">设备类型</param>
        /// <param name="pushType">推送类型</param>
        /// <param name="messageKey">信息标识</param>
        /// <param name="title">标题</param>
        /// <param name="tag">推送信息为Tag时需要设置此值</param>
        /// <param name="description">内容</param>
        /// <param name="userId">推送userid</param>
        /// <param name="channelId">推送channelid</param>
        /// <param name="deployStatus">推送环境，设备类型为苹果时需要选择，默认产品环境</param>
        /// <returns></returns>
        public static string PushNotification(DeviceType deviceType, PushType pushType, string title, string description, string userId, string channelId, string tag, string messageKey = "iezupushNotification", DeployStatus deployStatus = DeployStatus.Pro)
        {
            try
            {
                BaiduPush Bpush = new BaiduPush("POST", sk);
                String apiKey = ak;
                String messages = "";
                String method = "push_msg";
                TimeSpan ts = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0));
                uint device_type = 3;
                uint unixTime = (uint)ts.TotalSeconds;

                uint message_type;
                string messageksy = messageKey;
                message_type = 1;

                if (deviceType==DeviceType.IOS)
                {
                    device_type = 4;
                    IOSNotification notification = new IOSNotification();
                    notification.title = title;
                    notification.description = description;
                    messages = notification.getJsonString();
                }
                else
                {
                    var notification = new BaiduPushNotification {title = title, description = description};
                    messages = notification.getJsonString();
                }

                PushOptions pOpts;
                if (pushType==PushType.User)
                {
                    pOpts = new PushOptions(method, apiKey, userId,channelId, device_type, messages, messageksy, unixTime);
                }
                else if (pushType == PushType.Tag)
                {
                    pOpts = new PushOptions(method, apiKey, tag, device_type, messages, messageksy, unixTime);
                }
                else
                {
                    pOpts = new PushOptions(method, apiKey, device_type, messages, messageksy, unixTime);
                }

                pOpts.message_type = message_type;
                if (deviceType == DeviceType.IOS)
                {
                    if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 2;
                    }
                    else if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 1;
                    }
                }

                string response = Bpush.PushMessage(pOpts);
                return response;
            }
            catch (Exception ex)
            {
                return "Exception caught sending update: " + ex.ToString();
            }
        }

        /// <summary>
        /// 百度云推送消息
        /// </summary>
        /// <param name="deviceType">设备类型</param>
        /// <param name="pushType">推送类型</param>
        /// <param name="message">消息内容</param>
        /// <param name="userId">百度云推送userid</param>
        /// <param name="channelId">百度云推送channelid</param>
        /// <param name="tag">推送类型为Tag时需设置此项</param>
        /// <param name="messageKey">消息标识</param>
        /// <param name="deployStatus">推送环境，设备类型为ios时需设置此项，默认为产品环境</param>
        /// <param name="usertype">0  乘客 1 司机</param>
     
        /// <returns></returns>
        public static string PushMessage(DeviceType deviceType, PushType pushType, string message,string userId, string channelId, string tag, string messageKey = "iezupushMessage", DeployStatus deployStatus = DeployStatus.Pro)
        {
            try
            {
                string secretKey = sk;
              
                BaiduPush Bpush = new BaiduPush("POST", secretKey);
                String apiKey = ak; 
                String messages = "";
                String method = "push_msg";
                TimeSpan ts = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0));
                uint device_type = 3;
                uint unixTime = (uint)ts.TotalSeconds;

                uint message_type;
                string messageksy = messageKey;

                message_type = 0;
                messages = message;

                PushOptions pOpts;
                if (pushType == PushType.User)
                {
                    pOpts = new PushOptions(method, apiKey, userId, channelId, device_type, messages, messageksy, unixTime);
                }
                else if (pushType == PushType.Tag)
                {
                    pOpts = new PushOptions(method, apiKey, tag, device_type, messages, messageksy, unixTime);
                }
                else
                {
                    pOpts = new PushOptions(method, apiKey, device_type, messages, messageksy, unixTime);
                }

                pOpts.message_type = message_type;
                if (deviceType == DeviceType.IOS)
                {
                    if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 2;
                    }
                    else if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 1;
                    }
                }

                string response = Bpush.PushMessage(pOpts);
                return response;
            }
            catch (Exception ex)
            {
                return "Exception caught sending update: " + ex.ToString();
            }
        }

        public static string PushMessageToCustomer(DeviceType deviceType, PushType pushType, string message, string userId, string channelId, string tag, string messageKey = "iezupushClientMessage", DeployStatus deployStatus = DeployStatus.Pro)
        {
            try
            {
                string secretKey = clientsk;

                BaiduPush Bpush = new BaiduPush("POST", secretKey);
                String apiKey = clientak;
                String messages = "";
                String method = "push_msg";
                TimeSpan ts = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0));
                uint device_type = 3;
                uint unixTime = (uint)ts.TotalSeconds;

                uint message_type;
                string messageksy = messageKey;

                message_type = 0;
                messages = message;

                PushOptions pOpts;
                if (pushType == PushType.User)
                {
                    pOpts = new PushOptions(method, apiKey, userId, channelId, device_type, messages, messageksy, unixTime);
                }
                else if (pushType == PushType.Tag)
                {
                    pOpts = new PushOptions(method, apiKey, tag, device_type, messages, messageksy, unixTime);
                }
                else
                {
                    pOpts = new PushOptions(method, apiKey, device_type, messages, messageksy, unixTime);
                }
                pOpts.message_type = message_type;
                if (deviceType == DeviceType.IOS)
                {
                    if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 2;
                    }
                    else if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 1;
                    }
                }

                string response = Bpush.PushMessage(pOpts);
                return response;
            }
            catch (Exception ex)
            {
                return "Exception caught sending update: " + ex.ToString();
            }
        }
        public static string PushNotificationToCustomer(DeviceType deviceType, PushType pushType, string title, string description, string userId, string channelId, string tag, string messageKey = "iezupushClientNotification", DeployStatus deployStatus = DeployStatus.Pro)
        {
            try
            {
                BaiduPush Bpush = new BaiduPush("POST", clientsk);
                String apiKey = clientak;
                String messages = "";
                String method = "push_msg";
                TimeSpan ts = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0));
                uint device_type = 3;
                uint unixTime = (uint)ts.TotalSeconds;

                uint message_type;
                string messageksy = messageKey;
                message_type = 1;

                if (deviceType == DeviceType.IOS)
                {
                    device_type = 4;
                    IOSNotification notification = new IOSNotification();
                    notification.title = title;
                    notification.description = description;
                    messages = notification.getJsonString();
                }
                else
                {
                    var notification = new BaiduPushNotification { title = title, description = description };
                    messages = notification.getJsonString();
                }

                PushOptions pOpts;
                if (pushType == PushType.User)
                {
                    pOpts = new PushOptions(method, apiKey, userId, channelId, device_type, messages, messageksy, unixTime);
                }
                else if (pushType == PushType.Tag)
                {
                    pOpts = new PushOptions(method, apiKey, tag, device_type, messages, messageksy, unixTime);
                }
                else
                {
                    pOpts = new PushOptions(method, apiKey, device_type, messages, messageksy, unixTime);
                }

                pOpts.message_type = message_type;
                if (deviceType == DeviceType.IOS)
                {
                    if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 2;
                    }
                    else if (deployStatus == DeployStatus.Pro)
                    {
                        pOpts.deploy_status = 1;
                    }
                }

                string response = Bpush.PushMessage(pOpts);
                return response;
            }
            catch (Exception ex)
            {
                return "Exception caught sending update: " + ex.ToString();
            }
        }

    }
}
