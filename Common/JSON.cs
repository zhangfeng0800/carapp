using System;
using System.Web;

namespace Common
{
    public static class JSON
    {
        #region 页面参数检测

        public static void CheckQuery(string[] MustQSArray)
        {
            if (HttpContext.Current.Request.Url.Query == "")
            {
                ShowMessage("无操作");
            }

            for (int i = 0, max = HttpContext.Current.Request.QueryString.Count; i < max; i++)
            {
                String QS = HttpContext.Current.Request.QueryString[i];

                if (QS == "" && Array.IndexOf(MustQSArray, QS) != -1)
                {
                    ShowMessage("参数错误");
                }
            }
        }

        #endregion

        #region 显示信息

        public static void ShowMessage(string Message)
        {
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.Write("{\"Message\":\"" + Message + "\"}");
            HttpContext.Current.Response.End();
        }

        public static void ShowMessage(string TagName, string Message)
        {
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.Write("{\"TagName\":\"" + TagName + "\",\"\":\"" + Message + "\"}");
            HttpContext.Current.Response.End();
        }

        #endregion
    }
}