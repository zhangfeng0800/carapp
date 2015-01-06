using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Configuration;
using BLL;
using IEZU.Log;
using Newtonsoft.Json;
using Quartz;
using Quartz.Impl;
using Quartz.Impl.Triggers;

namespace CarAppAdminWebUI.Quartz
{
    public class OrderAlarmScheduler
    {
        public static void Run()
        {
            DateTimeOffset runTime = DateBuilder.EvenMinuteDate(DateTimeOffset.UtcNow);

            ISchedulerFactory factory = new StdSchedulerFactory();
            IScheduler scheduler = factory.GetScheduler();
            IJobDetail job = JobBuilder.Create<OrderRefreshJob>().WithIdentity("job2", "group2").Build();
            ITrigger trigger = TriggerBuilder.Create().WithIdentity("trigger2", "group1").StartAt(runTime).Build();
            var trigger1 = new SimpleTriggerImpl("trigger2", "group2", DateTime.Now.AddSeconds(10), null, -1, TimeSpan.FromMilliseconds(1000));
            scheduler.ScheduleJob(job, trigger1);
            scheduler.Start();

        }
    }

   
    public class OrderRefreshJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            var orderbll = new OrderBLL(); 
            var flags = 0;
            orderbll.OrderRefresh(out flags);
            if (flags==1)
            {
                var url = WebConfigurationManager.AppSettings["orderpushaddr"];
                GetWebRequest(url);
            }
        }
        public static string GetWebRequest(string url)
        {
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(url);
                var response = request.GetResponse();
                var stream = response.GetResponseStream();
                if (stream != null)
                {
                    var reader = new StreamReader(stream);
                    var data = reader.ReadToEnd();
                    stream.Close();
                    reader.Close();
                    return data;
                }
                return "";
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                return exception.Message;
            }

        }
    }
}