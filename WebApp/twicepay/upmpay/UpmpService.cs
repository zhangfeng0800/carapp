using System;
using System.Data;
using System.Configuration;
using System.Text;
using System.Collections.Generic;

namespace Com.UnionPay.Upmp
{

    /// <summary>
    /// ������UpmpService
    /// ���ܣ��ӿڴ��������, ��ת�������󣬷��ͱ��ģ�����Ӧ����
    /// �汾��1.0
    /// ���ڣ�2013-1-30
    /// ���ߣ��й�����UPMP�Ŷ�
    /// ��Ȩ���й�����
    /// ˵�������´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ�����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣�ô�������ο���
    /// </summary>
    public class UpmpService
    {
        /// <summary>
        /// ���׽ӿڴ���
        /// </summary>
        /// <param name="req">����Ҫ��</param>
        /// <param name="resp">Ӧ��Ҫ��</param>
        /// <returns>�Ƿ�ɹ�</returns>
        public static bool Trade(Dictionary<String, String> req, Dictionary<String, String> resp)
        {
            String nvp = BuildReq(req, resp);
            String respString = UpmpCore.Post(UpmpConfig.GetInstance().TRADE_URL, nvp);
            return VerifyResponse(respString, resp);

        }

        /// <summary>
        /// ���ײ�ѯ����
        /// </summary>
        /// <param name="req">����Ҫ��</param>
        /// <param name="resp">Ӧ��Ҫ��</param>
        /// <returns>�Ƿ�ɹ�</returns>
        public static bool Query(Dictionary<String, String> req, Dictionary<String, String> resp)
        {
            String nvp = BuildReq(req, resp);
            String respString = UpmpCore.Post(UpmpConfig.GetInstance().QUERY_URL, nvp);
            return VerifyResponse(respString, resp);
        }

        /// <summary>
        /// ƴ�ӱ�����
        /// </summary>
        /// <param name="req">����Ҫ��</param>
        /// <returns>������</returns>
        public static String BuildReserved(Dictionary<String, String> req)
        {
            StringBuilder merReserved = new StringBuilder();
            merReserved.Append("{");
            merReserved.Append(UpmpCore.CreateLinkString(req, false, true));
            merReserved.Append("}");
            return merReserved.ToString();
        }


        /// <summary>
        /// ƴ�������ַ���
        /// </summary>
        /// <param name="req"></param>
        /// <param name="resp"></param>
        /// <returns></returns>
        private static String BuildReq(Dictionary<String, String> req, Dictionary<String, String> resp)
        {
            // ����ǩ�����
            String signature = UpmpCore.BuildSignature(req);

            // ǩ�������ǩ����ʽ���������ύ��������
            req[UpmpConfig.GetInstance().SIGNATURE] = signature;
            req[UpmpConfig.GetInstance().SIGN_METHOD] = UpmpConfig.GetInstance().SIGN_TYPE;

            return UpmpCore.CreateLinkString(req, false, true);
        }

        /// <summary>
        /// �첽֪ͨ��Ϣ��֤
        /// </summary>
        /// <param name="para">�첽֪ͨ��Ϣ</param>
        /// <returns>��֤���</returns>
        public static bool VerifySignature(Dictionary<String, String> para)
        {
            String signature = UpmpCore.BuildSignature(para);
            String respSignature = para[UpmpConfig.GetInstance().SIGNATURE];
            if (null != respSignature && respSignature.Equals(signature))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// Ӧ�����
        /// </summary>
        /// <param name="respString">Ӧ����</param>
        /// <param name="resp">Ӧ��Ҫ��</param>
        /// <returns>Ӧ���Ƿ�ɹ�</returns>
        private static bool VerifyResponse(String respString, Dictionary<String, String> resp)
        {
            if (respString != null && !"".Equals(respString))
            {
                // ����Ҫ��
                Dictionary<String, String> para;
                try
                {
                    para = UpmpCore.ParseQString(respString);
                }
                catch (Exception e)
                {
                    e.ToString();
                    return false;
                }
                bool signIsValid = VerifySignature(para);

                DictionaryPutAll(resp, para);

                if (signIsValid)
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            return false;
        }

        private static void DictionaryPutAll(Dictionary<String, String> dest, Dictionary<String, String> source)
        {
            foreach (KeyValuePair<string, string> pair in source)
            {
                dest[pair.Key] = pair.Value;
            }
        }
    }
}