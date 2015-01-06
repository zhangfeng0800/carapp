using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Common
{
    public class regexPath
    {
        public static string DoChange(string htmlString, string masterSiteUrl)
        {
            Regex reg = new Regex("<img.*?/>");
            MatchCollection matchs = reg.Matches(htmlString);
            foreach (var item in matchs)
            {
                if (item.ToString().Contains(masterSiteUrl))
                    continue;
                string oldImgPath = item.ToString();
                Regex reg2 = new Regex("src=\".*?\"");
                string newImgPath = reg2.Match(oldImgPath).ToString();
                newImgPath = newImgPath.Substring(5,newImgPath.Length-6);
                if (!newImgPath.Contains(masterSiteUrl))
                {
                    newImgPath = "<img width='100%' height='auto' src=\"" + masterSiteUrl + newImgPath + "\"/>";
                }
                htmlString = htmlString.Replace(oldImgPath, newImgPath);
            }
            return htmlString;
        }
    }
}
