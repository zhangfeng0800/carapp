using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Timers;
using System.Web;
using System.Web.Configuration;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using BLL;
using CarAppAdminWebUI.Quartz;
using Common;
using Model;
using NPOI.SS.Formula.Functions;


namespace CarAppAdminWebUI
{
    public class Global : System.Web.HttpApplication
    {
        private Timer Timer = new Timer(5000);
        private static Hashtable ExtenCollection = Hashtable.Synchronized(new Hashtable(StringComparer.OrdinalIgnoreCase));
        void Application_Start(object sender, EventArgs e)
        {
            RouteTable.Routes.MapHubs();
            Timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
            Timer.Start();
            OrderAlarmScheduler.Run();
        }

        void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            foreach (var exten in ExtenCollection.Keys)
            {
                var extenTimeStr = ExtenCollection[exten] as string;
                DateTime extenTime;
                extenTime = !string.IsNullOrEmpty(extenTimeStr) ? Convert.ToDateTime(extenTimeStr) : DateTime.Now;
                var url = WebConfigurationManager.AppSettings["callcenteraddr"];
                if ((DateTime.Now - extenTime).TotalSeconds > 20)
                {
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("groupid", "0");
                    parameters.Add("exten", exten.ToString());
                    parameters.Add("state", "0");

                    if (PingTool.PingServer(100, 10, url.Split(':')[0]))
                    {
                        var response = ServiceHelper.GetServiceResponse("http://" + url + "/CheckInOut", parameters);
                        if (response.Contains("success"))
                        {
                            ExtenCollection.Remove(exten);
                        }
                    }

                }
            }

        }

        public static void ExtenLogin(string exten)
        {
            if (ExtenCollection.ContainsKey(exten))
            {
                ExtenCollection[exten] = DateTime.Now.ToString();
            }
            else
            {
                ExtenCollection.Add(exten, DateTime.Now.ToString());
            }
        }

        public static void RemoveExten(string exten)
        {
            if (ExtenCollection.ContainsKey(exten))
            {
                ExtenCollection.Remove(exten);
            }
        }


        void Application_End(object sender, EventArgs e)
        {
            //  在应用程序关闭时运行的代码

        }

        void Application_Error(object sender, EventArgs e)
        {
            //全局处理错误
            /*try
            {
                Exception ex = Server.GetLastError();
                Exception iex = ex.InnerException;
                Server.ClearError();
                HttpContext.Current.Response.Write(
                    "<div style=\"margin-top: 15px; font-size: 12px;height: 300px; background: url(/Static/images/500.jpg) no-repeat 50% 50%;\">");
                _errorLogBll.AddException(iex ?? ex);
            }
            catch (Exception ex)
            {
                _errorLogBll.AddException(ex);
            }*/
        }

        void Session_Start(object sender, EventArgs e)
        {
            // 在新会话启动时运行的代码

        }

        void Session_End(object sender, EventArgs e)
        {
            // 在会话结束时运行的代码。 
            // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
            // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer 
            // 或 SQLServer，则不会引发该事件。
        }
    }
}
