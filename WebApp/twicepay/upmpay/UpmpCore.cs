using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Net;
using System.IO;

namespace Com.UnionPay.Upmp
{

    /// <summary>
    /// ������UpmpCore
    /// ���ܣ����׷���ӿڹ��ú�����
    /// �汾��1.0
    /// ���ڣ�2013-1-30
    /// ���ߣ��й�����UPMP�Ŷ�
    /// ��Ȩ���й�����
    /// ˵�������´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ�����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣�ô�������ο���
    /// </summary>
    public class UpmpCore
    {
        public const String QSTRING_SPLIT = "&";
        public const String QSTRING_EQUAL = "=";

        /// <summary>
        /// ��ȥ����Ҫ���еĿ�ֵ��ǩ������
        /// </summary>
        /// <param name="para">����Ҫ��</param>
        /// <returns>ȥ����ֵ��ǩ�������������Ҫ��</returns>
        public static Dictionary<String, String> ParaFilter(Dictionary<String, String> para)
        {
            Dictionary<String, String> result = new Dictionary<String, String>();

            if (para == null || para.Count <= 0) {
                return result;
            }

            foreach (String key in para.Keys) {
                String value = para[key];
                if (value == null || value.Equals("") || String.Equals(key,UpmpConfig.GetInstance().SIGNATURE,StringComparison.CurrentCultureIgnoreCase) 
                    || String.Equals(key,UpmpConfig.GetInstance().SIGN_METHOD,StringComparison.CurrentCultureIgnoreCase)){
                    continue;
                }
                result[key] = value;
            }

            return result;
        }

        /// <summary>
        /// ����ǩ��
        /// </summary>
        /// <param name="req">��Ҫǩ����Ҫ��</param>
        /// <returns>ǩ������ַ���</returns>
        public static String BuildSignature(Dictionary<String, String> req)
        {
            // ��ȥ�����еĿ�ֵ��ǩ������
            Dictionary<String, String> para = ParaFilter(req);
            String prestr = CreateLinkString(para, true, false);
            prestr = prestr + QSTRING_SPLIT + MD5(UpmpConfig.GetInstance().SECURITY_KEY);
            return MD5(prestr);
        }

        /// <summary>
        /// ������Ҫ�ذ��ա�����=����ֵ����ģʽ�á�&���ַ�ƴ�ӳ��ַ���
        /// </summary>
        /// <param name="para">����Ҫ��</param>
        /// <param name="sort">�Ƿ���Ҫ����keyֵ����������</param>
        /// <param name="encode">�Ƿ���ҪURL����</param>
        /// <returns>ƴ�ӳɵ��ַ���</returns>
        public static String CreateLinkString(Dictionary<String, String> para, bool sort, bool encode)
        {
            List<String> list = new List<String>(para.Keys);

            if (sort)
                list.Sort();

            StringBuilder sb = new StringBuilder();
            foreach (String key in list)
            {
                String value = para[key];
                if (encode && value != null)
                {
                    try
                    {
                        value = HttpUtility.UrlEncode(value, Encoding.GetEncoding(UpmpConfig.GetInstance().CHARSET)); 
                    }
                    catch (Exception ex)
                    {
                        //LogError(ex);
                        return "#ERROR: HttpUtility.UrlEncode Error!" + ex.Message;
                    }
                }

                sb.Append(key).Append(QSTRING_EQUAL).Append(value).Append(QSTRING_SPLIT);

            }

            return sb.Remove(sb.Length-1, 1).ToString();
        }

        /// <summary>
        /// ����Ӧ���ַ���������Ӧ��Ҫ��
        /// </summary>
        /// <param name="str">��Ҫ�������ַ���</param>
        /// <returns>�����Ľ��map</returns>
        public static Dictionary<String, String> ParseQString(String str)
        {

            Dictionary<String, String> Dictionary = new Dictionary<String, String>();
            int len = str.Length;
            StringBuilder temp = new StringBuilder();
            char curChar;
            String key = null;
            bool isKey = true;

            for (int i = 0; i < len; i++)
            {// �����������������ַ���
                curChar = str[i];// ȡ��ǰ�ַ�

                if (curChar == '&')
                {// �����ȡ��&�ָ��
                    putKeyValueToDictionary(temp, isKey, key, Dictionary);
                    temp = new StringBuilder();
                    isKey = true;
                }
                else
                {
                    if (isKey)
                    {// �����ǰ���ɵ���key
                        if (curChar == '=')
                        {// �����ȡ��=�ָ���
                            key = temp.ToString();
                            temp = new StringBuilder();
                            isKey = false;
                        }
                        else
                        {
                            temp.Append(curChar);
                        }
                    }
                    else
                    {// �����ǰ���ɵ���value
                        temp.Append(curChar);
                    }
                }
            }

            putKeyValueToDictionary(temp, isKey, key, Dictionary);

            return Dictionary;
        }

        private static void putKeyValueToDictionary(StringBuilder temp, bool isKey, String key, Dictionary<String, String> Dictionary)
        {
            if (isKey)
            {
                key = temp.ToString();
                if (key.Length == 0)
                {
                    throw new System.Exception("QString format illegal");
                }
                Dictionary[key]="";
            }
            else
            {
                if (key.Length == 0)
                {
                    throw new System.Exception("QString format illegal");
                }

                Dictionary[key] = HttpUtility.UrlDecode(temp.ToString(), Encoding.GetEncoding(UpmpConfig.GetInstance().CHARSET));
            }
        }

        /// <summary>
        /// http�Ļ���post����
        /// </summary>
        /// <param name="url">URL��ַ</param>
        /// <param name="postData">post����������</param>
        /// <returns>���������ص�����</returns>
        public static string Post(string url, string postData)
        {
            byte[] byteArray = Encoding.UTF8.GetBytes(postData);
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.ContentType = "application/x-www-form-urlencoded";
                request.Timeout = 30000;
                request.Method = "POST";
                request.ContentLength = byteArray.Length;

                Stream requestStream = request.GetRequestStream();
                requestStream.Write(byteArray, 0, byteArray.Length);
                requestStream.Close();

                HttpWebResponse webResponse = (HttpWebResponse)request.GetResponse();
                StreamReader reader = new StreamReader(webResponse.GetResponseStream(), Encoding.UTF8);
                String sResult = reader.ReadToEnd();
                reader.Close();
                return sResult;
            }
            catch (Exception ex)
            {
                return "<error>" + ex.Message + "</error>";
            }

        }

        /// <summary>
        /// ����MD5
        /// </summary>
        /// <param name="str">����MD5�������ַ���</param>
        /// <returns>MD5��Ľ��</returns>
        public static string MD5(string str)
        {
            byte[] MD5Source = Encoding.GetEncoding(UpmpConfig.GetInstance().CHARSET).GetBytes(str);

            System.Security.Cryptography.MD5CryptoServiceProvider get_md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] hash_byte = get_md5.ComputeHash(MD5Source, 0, MD5Source.Length);
            string result = System.BitConverter.ToString(hash_byte);
            result = result.Replace("-", "");

            return result.ToLower();
        }

    }
}