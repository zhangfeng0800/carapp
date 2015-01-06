using System;
using System.Security.Cryptography;
using System.Text;

namespace Common
{
    /// <summary>
    /// Summary description for AES
    /// </summary>
    public static class AES
    {
        #region 密钥

        private static readonly String strAesKey = (System.Web.HttpContext.Current.Request.ServerVariables["Http_Host"] + "fangrun-Copyright-http://www.iezu.cn").Substring(0,32);//加密所需32位密匙
        
        #endregion

        #region 加密

        /// <summary>
        /// AES加密
        /// </summary>
        /// <param name="str">要加密字符串</param>
        /// <returns>返回加密后字符串</returns>
        public static String StrEncrypt(String str)
        {
            Byte[] keyArray = System.Text.UTF8Encoding.UTF8.GetBytes(strAesKey);
            Byte[] toEncryptArray = System.Text.UTF8Encoding.UTF8.GetBytes(str);
            System.Security.Cryptography.RijndaelManaged rDel = new System.Security.Cryptography.RijndaelManaged();
            rDel.Key = keyArray;
            rDel.Mode = System.Security.Cryptography.CipherMode.ECB;
            rDel.Padding = System.Security.Cryptography.PaddingMode.PKCS7;
            System.Security.Cryptography.ICryptoTransform cTransform = rDel.CreateEncryptor();
            Byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }

        #endregion

        #region 解密

        //解密的代码：
        /// <summary>
        /// AES解密  
        /// </summary>  
        /// <param name="str">要解密字符串</param>  
        /// <returns>返回解密后字符串</returns>
        public static String StrDecrypt(String str)
        {
            Byte[] keyArray = System.Text.UTF8Encoding.UTF8.GetBytes(strAesKey);
            Byte[] toEncryptArray = Convert.FromBase64String(str);
            System.Security.Cryptography.RijndaelManaged rDel = new System.Security.Cryptography.RijndaelManaged();
            rDel.Key = keyArray;
            rDel.Mode = System.Security.Cryptography.CipherMode.ECB;
            rDel.Padding = System.Security.Cryptography.PaddingMode.PKCS7;
            System.Security.Cryptography.ICryptoTransform cTransform = rDel.CreateDecryptor();
            Byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            return System.Text.UTF8Encoding.UTF8.GetString(resultArray);
        }

        #endregion

        #region 加密

        /// <summary>
        /// AES加密，必须是可序列化对象
        /// </summary>
        /// <param name="str">要加密字符串</param>
        /// <returns>返回加密后字符串</returns>
        public static String ObjEncrypt(Object obj)
        {
            Byte[] keyArray = System.Text.UTF8Encoding.UTF8.GetBytes(strAesKey);
            Byte[] toEncryptArray = Tool.Serialize(obj);
            System.Security.Cryptography.RijndaelManaged rDel = new System.Security.Cryptography.RijndaelManaged();
            rDel.Key = keyArray;
            rDel.Mode = System.Security.Cryptography.CipherMode.ECB;
            rDel.Padding = System.Security.Cryptography.PaddingMode.PKCS7;
            System.Security.Cryptography.ICryptoTransform cTransform = rDel.CreateEncryptor();
            Byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }

        #endregion

        #region 解密

        //解密的代码：
        /// <summary>
        /// AES解密  
        /// </summary>  
        /// <param name="str">要解密字符串</param>  
        /// <returns>返回解密后字符串</returns>
        public static Object ObjDecrypt(String str)
        {
            Byte[] keyArray = System.Text.UTF8Encoding.UTF8.GetBytes(strAesKey);
            Byte[] toEncryptArray = Convert.FromBase64String(str);
            System.Security.Cryptography.RijndaelManaged rDel = new System.Security.Cryptography.RijndaelManaged();
            rDel.Key = keyArray;
            rDel.Mode = System.Security.Cryptography.CipherMode.ECB;
            rDel.Padding = System.Security.Cryptography.PaddingMode.PKCS7;
            System.Security.Cryptography.ICryptoTransform cTransform = rDel.CreateDecryptor();
            Byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            return Common.Tool.Deserialize(resultArray);
        }

        #endregion

        #region MD5加密
        public static string MD5Encrypt(string str)
        {
            string cl = str;
            string pwd = "";
            MD5 md5 = MD5.Create();
            byte[] s = md5.ComputeHash(Encoding.UTF8.GetBytes(cl));
            for (int i = 0; i < s.Length; i++)
            {
                pwd = pwd + s[i].ToString("X");
            }
            return pwd;
        } 
        #endregion
    }

}