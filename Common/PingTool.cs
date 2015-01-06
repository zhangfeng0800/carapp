using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;
using System.Web.Configuration;

namespace Common
{
    public class PingTool
    {
        public static bool PingServer(int interval,int times,string url)
        {
            var count = 0;
            Ping ping = new Ping();
            var result = false;
            while (count < times)
            {
                var replay = ping.Send(url, interval);
                if (replay == null || replay.Status != IPStatus.Success)
                {
                    count++;
                    result = false; 
                }
                else
                {

                    result = true;
                }
                if (result)
                {
                    break;
                }
            }
            Debug.WriteLine(url + result.ToString());
          Trace.WriteLine(url+result.ToString());
            return result;
        }
    }
}
