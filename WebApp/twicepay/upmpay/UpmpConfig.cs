using System.Web;
using System.Text;
using System.IO;
using System.Net;
using System;
using System.Collections.Generic;
using System.Web.Configuration;

namespace Com.UnionPay.Upmp
{
    /// <summary>
    /// ������UpmpConfig
    /// ���ܣ�������
    /// �汾��1.0
    /// ���ڣ�2013-1-30
    /// ���ߣ��й�����UPMP�Ŷ�
    /// ��Ȩ���й�����
    /// ˵�������´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ�����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣�ô�������ο���
    /// </summary>
    public class UpmpConfig
    {

        #region �ֶ�
        // �汾��
        public String VERSION;

        // ���뷽ʽ
        public String CHARSET;

        // ������ַ
        public String TRADE_URL;

        // ��ѯ��ַ
        public String QUERY_URL;

        // �̻�����
        public String MER_ID;

        // ֪ͨURL
        public String MER_BACK_END_URL;

        // ����URL
        public String MER_FRONT_RETURN_URL;

        // ǰ̨֪ͨURL
        public String MER_FRONT_END_URL;

        // ����URL

        // ���ܷ�ʽ
        public String SIGN_TYPE;

        // �̳��ܳף���Ҫ�������̻���վ�����õ�һ��
        public String SECURITY_KEY;

        // �ɹ�Ӧ����
        public String RESPONSE_CODE_SUCCESS = "00";


        // ǩ��
        public String SIGNATURE = "signature";

        // ǩ������
        public String SIGN_METHOD = "signMethod";

        // Ӧ����
        public String RESPONSE_CODE = "respCode";

        // Ӧ����Ϣ
        public String RESPONSE_MSG = "respMsg";

        #endregion

        private UpmpConfig()
        {
            //�����������������������������������Ļ�����Ϣ������������������������������
            MER_ID = "898110248990403";
            SECURITY_KEY = "xBVDAWEtbkK4Q5bZ6zbNsuD6Ty5bPxBK";

            MER_BACK_END_URL = WebConfigurationManager.AppSettings["paybackUrl"].ToString()+"/twicepay/UPMPcallback.aspx";
            MER_FRONT_END_URL = WebConfigurationManager.AppSettings["paybackUrl"].ToString()+"/twicepay/UPMPcallback.aspx";

            VERSION = "1.0.0";
            CHARSET = "UTF-8";
            SIGN_TYPE = "MD5";

            TRADE_URL = "https://mgate.unionpay.com/gateway/merchant/trade";
            QUERY_URL = "https://mgate.unionpay.com/gateway/merchant/query";
        }

        private static UpmpConfig _instance;

        /// <summary>
        /// ��ȡUpmpConfig����
        /// </summary>
        /// <returns></returns>
        public static UpmpConfig GetInstance()
        {
            if (_instance == null)
            {
                _instance = new UpmpConfig();
            }

            return _instance;
        }
    }
}