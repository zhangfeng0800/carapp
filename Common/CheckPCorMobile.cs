using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{
    public class CheckPCorMobile
    {
        /// <summary>
        /// 获取客户端浏览器的系统类型
        /// </summary>
        /// <param name="userAgent">Request.UserAgent</param>
        /// <param name="browserName">返回的浏览器终端系统类型，目前就3种，Android，IPhone，WindowsPhone</param>
        /// <returns>手机为true，电脑为flase</returns>
        public bool CheckBrower(string userAgent, out string browserName)
        {
            if (userAgent.ToLower().Contains("android"))
            {
                browserName = "Android";
                return true;
            }
            if (userAgent.ToLower().Contains("ucbrowser"))
            {
                browserName = "UC";
                return true;
            }
            if (userAgent.ToLower().Contains("iphone"))
            {
                browserName = "IPhone";
                return true;
            }
            if (userAgent.ToLower().Contains("wpdesktop"))
            {
                browserName = "WindowsPhone";
                return true;
            }
            else
            {
                browserName = "PC";
                return false;
            }
        }
    }
}
