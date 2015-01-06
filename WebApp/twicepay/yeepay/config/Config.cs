using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Configuration;

namespace WebApp
{
    class Config
    {
        static Config()
        {
            merchantAccount = WebConfigurationManager.AppSettings["merchantAccount"];
            merchantPublickey = WebConfigurationManager.AppSettings["merchantPublickey"];
            merchantPrivatekey = WebConfigurationManager.AppSettings["merchantPrivatekey"];
            yibaoPublickey = WebConfigurationManager.AppSettings["yibaoPublickey"];
        }
        public static string merchantAccount
        { get; set; }

        public static string merchantPublickey
        { get; set; }

        public static string merchantPrivatekey
        { get; set; }

        public static string yibaoPublickey
        { get; set; }
    }
}
