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
    /// 类名：UpmpConfig
    /// 功能：配置类
    /// 版本：1.0
    /// 日期：2013-1-30
    /// 作者：中国银联UPMP团队
    /// 版权：中国银联
    /// 说明：以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己的需要，按照技术文档编写,并非一定要使用该代码。该代码仅供参考。
    /// </summary>
    public class UpmpConfig
    {

        #region 字段
        // 版本号
        public String VERSION;

        // 编码方式
        public String CHARSET;

        // 交易网址
        public String TRADE_URL;

        // 查询网址
        public String QUERY_URL;

        // 商户代码
        public String MER_ID;

        // 通知URL
        public String MER_BACK_END_URL;

        // 返回URL
        public String MER_FRONT_RETURN_URL;

        // 前台通知URL
        public String MER_FRONT_END_URL;

        // 返回URL

        // 加密方式
        public String SIGN_TYPE;

        // 商城密匙，需要和银联商户网站上配置的一样
        public String SECURITY_KEY;

        // 成功应答码
        public String RESPONSE_CODE_SUCCESS = "00";


        // 签名
        public String SIGNATURE = "signature";

        // 签名方法
        public String SIGN_METHOD = "signMethod";

        // 应答码
        public String RESPONSE_CODE = "respCode";

        // 应答信息
        public String RESPONSE_MSG = "respMsg";

        #endregion

        private UpmpConfig()
        {
            //↓↓↓↓↓↓↓↓↓↓请在这里配置您的基本信息↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
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
        /// 获取UpmpConfig单例
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