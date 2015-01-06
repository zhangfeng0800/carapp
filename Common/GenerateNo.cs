using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{
    public class GenerateNo
    {
        public static string GenerateUniqueText(int num)
        {
            string randomResult = string.Empty;
            const string readyStr = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            var rtn = new char[num];
            var gid = Guid.NewGuid();
            var ba = gid.ToByteArray();
            for (var i = 0; i < num; i++)
            {
                rtn[i] = readyStr[((ba[i] + ba[num + i]) % 35)];
            }
            return rtn.Aggregate(randomResult, (current, r) => current + r);
        }
        public static string GenerateUniqueOrderNo(int num)
        {
            var date = DateTime.Now;
            string randomResult = string.Empty;
            const string readyStr = "0123456789";
            var rtn = new char[num];
            var gid = Guid.NewGuid();
            var ba = gid.ToByteArray();
            for (var i = 0; i < num; i++)
            {
                rtn[i] = readyStr[((ba[i] + ba[num + i]) % 10)];
            }
            randomResult = rtn.Aggregate(randomResult, (current, r) => current + r);
            return date.ToString("yyyyMMddHHmmss") + randomResult + "|" + date.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }
}
