using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;

namespace Common
{
    public class Logger
    {
        private static ILog log;

        static Logger()
        {
            log = log4net.LogManager.GetLogger("LogFileAppender");
        }

        public static void Info(string msg)
        {
            log.Info(msg);
        }

        public static void Debug(string msg)
        {
            log.Debug(msg);
        }

        public static void Error(Exception exception)
        {
            log.Error("发生错误：", exception);
        }

        public static void Fatal(Exception exception)
        {
            log.Fatal("执行失败",exception);
        }

        public static void Warn(string msg)
        {
            log.Warn(msg);
        }
    }
}
