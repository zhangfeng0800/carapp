﻿using System;
using System.Collections.Generic;
using System.Text;

namespace WebApp
{
    class APIURLConfig
    {
        static APIURLConfig()
        {
            apiprefix = "https://ok.yeepay.com/payapi";
            merchantPrefix = "https://ok.yeepay.com/merchant";//生产环境
            //通用网页支付地址（包括借记卡和信用卡）
            webpayURI = "/mobile/pay/request";
            //借记卡网页支付地址
            debitWebpayURI = "/mobile/pay/bankcard/debit/request";
            //信用卡网页支付地址
            creditWebpayURI = "/mobile/pay/bankcard/credit/request";
            //绑卡支付接口
            bindpayURI = "/api/bankcard/bind/pay/request";
            //发生短信验证码接口
            sendValidateCodeURI = "/api/validatecode/send";
            //确认支付
            confirmPayURI = "/api/async/bankcard/pay/confirm/validatecode";
            //支付结果查询接口
            queryPayResultURI="/api/query/order";
            //获取绑卡列表
            bindlistURI = "/api/bankcard/bind/list";
            //根据银行卡卡号检查银行卡是否可以使用一键支付
            bankcardCheckURI = "/api/bankcard/check";
            //解绑接口
            unbindURI = "/api/bankcard/unbind";
            //直接退款
            directFundURI = "/query_server/direct_refund";
            //交易记录查询
            queryOrderURI = "/query_server/pay_single";
            //退款订单查询
            queryRefundURI = "/query_server/refund_single";
         }
        public static string apiprefix
        { get; set; }

        public static string merchantPrefix
        { get; set; }

        public static string webpayURI
        { get; set; }

        public static string creditWebpayURI
        { get; set; }

        public static string debitWebpayURI
        { get; set; }

        public static string bindpayURI
        { get; set; }

        public static string bindlistURI
        { get; set; }

        public static string bindcheckURI
        { get; set; }

        public static string bankcardCheckURI
        { get; set; }

        public static string queryPayResultURI
        { get; set; }

        public static string unbindURI
        { get; set; }

        public static string directFundURI
        { get; set; }

        public static string queryOrderURI
        { get; set; }

        public static string queryRefundURI
        { get; set; }

        public static string sendValidateCodeURI
        { get; set; }

        public static string confirmPayURI
        { get; set; }
    }
}
