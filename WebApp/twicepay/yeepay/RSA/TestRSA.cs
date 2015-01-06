using System;
using System.Collections.Generic;
using System.Text;
namespace WebApp
{
    class TestRSA
    {
        public static void testRSA()
        {
            string publickey = Config.merchantPublickey;
            string privatekey = Config.merchantPrivatekey;		
            //加密字符串
            string data = "1234567890123456";
            Console.WriteLine("加密前字符串内容："+data);
            //加密
            string encrypteddata = RSAFromPkcs8.encryptData(data, publickey, "UTF-8");
            Console.WriteLine("加密后的字符串为：" + encrypteddata);
            Console.WriteLine("解密后的字符串内容：" + RSAFromPkcs8.decryptData(encrypteddata, privatekey, "UTF-8"));
            //签名
            string signdata = "YB010000001441234567286038508081299";
            Console.WriteLine("签名前的字符串内容：" + signdata);
            string sign = RSAFromPkcs8.sign(signdata, privatekey, "UTF-8");
            Console.WriteLine("签名后的字符串：" + sign);
            Console.WriteLine("RSA算法测试结束");
            Console.ReadLine();
        }
    }
}
