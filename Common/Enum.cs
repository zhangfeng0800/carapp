using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Common
{
    public enum UserType
    {
        /// <summary>
        /// 集团管理员
        /// </summary>
        EnterPrizeManager = 0,
        /// <summary>
        /// 部门经理
        /// </summary>
        DepartmentManager = 1,
        /// <summary>
        /// 部门员工
        /// </summary>
        Employee = 2,
        OrdernaryUser = 3
    }

    public enum TaxPayerType
    {
        个人 = 0,
        单位 = 1
    }

    public enum TaxType
    {
        普通发票 = 0,
        增值税发票 = 1
    }
    public enum SMSTemp
    {
        /// <summary>
        /// 注册验证
        /// </summary>
        UserRegister = 0,

        /// <summary>
        /// 修改手机号码
        /// </summary>
        UserChangeMobile = 1,

        /// <summary>
        /// 修改密码
        /// </summary>
        UserChangePassword = 2,

        /// <summary>
        /// 创建用户通知
        /// </summary>
        UserCreateNewUser = 3,

        /// <summary>
        /// 订单确认
        /// </summary>
        UserOrderConfirm = 5,

        /// <summary>
        /// 车辆调配完成
        /// </summary>
        UserCarSetted = 10,

        /// <summary>
        /// 司机已出发_乘车人
        /// </summary>
        UserCarLeaveForPassenger = 15,

        /// <summary>
        /// 司机已出发_下单人
        /// </summary>
        UserCarLeave = 16,

        /// <summary>
        /// 司机已到达_乘车人
        /// </summary>
        UserCarArrivalForPassenger = 20,

        /// <summary>
        /// 司机已到达_下单人
        /// </summary>
        UserCarArrival = 21,

        /// <summary>
        /// 需要二次付款_下单人
        /// </summary>
        UserSecondPayNeed = 25,
        TwicePayNeed = 93,
        RefoundMoney=94,
        /// <summary>
        /// 需要二次付款_乘车人
        /// </summary>
        UserSecondPayNeedForPassenger = 26,

        /// <summary>
        /// 二次付款完成
        /// </summary>
        UserSecondPaid = 30,

        /// <summary>
        /// 不需要付款支付
        /// </summary>
        UserSecondPayUnneed = 35,

        /// <summary>
        /// 客服修改用户登录密码
        /// </summary>
        UserKefuPwd = 41,

        /// <summary>
        /// 订单取消无需扣费（订单已经支付）
        /// </summary>
        UserOrderCancelNoPay = 40, 

        /// <summary>
        /// 订单取消且扣费
        /// </summary>
        UserOrderCancelAndPay = 45,

        /// <summary>
        /// 获得订单（订单下发）
        /// </summary>
        DriverGetOrder = 50,

        /// <summary>
        /// 车已到达
        /// </summary>
        DriverCarArrival = 55,

        /// <summary>
        /// 订单完成
        /// </summary>
        DriverOrderComplete = 60,

        /// <summary>
        /// 订单取消
        /// </summary>
        DriverOrderCancel = 65,

        /// <summary>
        /// 发票邮寄通知
        /// </summary>
        UserInvoicePosted = 70,

        /// <summary>
        /// 客服_新订单通知
        /// </summary>
        ServicerOrderNotice = 75,

        PayByAccount = 80,

        RegisterByMobile = 81,

        SendUserPaypwd = 82,

        ResetPayPassword = 85,

        NoPayOrderCancel = 86, //未支付订单取消短信


        FindLoginPassword = 87,

        /// <summary>
        /// 二次付款时，帐户余额足够，直接扣款
        /// </summary>
        UserSecondPaidUneed = 88,
        /// <summary>
        /// 二次付款完成并发送订单信息
        /// </summary>
        UserSecondPaidSucess = 89,
        ResendCar = 90,
        InformationToFormerDriver = 91,

        SendEditOrder = 92,
    }

    public enum CityType
    {
        province = 1,
        city = 2,
        town = 3,
        nolimit = 4
    }
    public enum OperationType
    {
        /// <summary>
        /// 添加操作
        /// </summary>
        Add = 1,
        /// <summary>
        /// 删除操作
        /// </summary>
        Delete = 2,
        /// <summary>
        /// 更新操作
        /// </summary>
        Update = 3,
        /// <summary>
        /// 查询操作
        /// </summary>
        Query = 4,
        /// <summary>
        /// 登录
        /// </summary>
        Login = 5,
        /// <summary>
        /// 退出
        /// </summary>
        LoginOut = 6
    }

    public enum OrderStatus
    {
        /// <summary>
        /// 等待确认
        /// </summary>
        等待确认 = 1,
        /// <summary>
        /// 等待服务
        /// </summary>
        等待服务 = 2,
        /// <summary>
        /// 服务中
        /// </summary>
        服务中 = 3,
        /// <summary>
        /// 服务结束
        /// </summary>
        服务结束 = 4,
        /// <summary>
        /// 服务取消
        /// </summary>
        服务取消 = 5,
        /// <summary>
        /// 订单完成
        /// </summary>
        订单完成 = 6,
        /// <summary>
        /// 司机等待
        /// </summary>
        司机等待 = 7,
        /// <summary>
        /// 等待派车
        /// </summary>
        等待派车 = 8,
        /// <summary>
        /// 二次付款中
        /// </summary>
        二次付款 = 9,
        司机已经出发 = 10,
        司机已经就位 = 11,
        订单已经接取 = 12
    }
    /// <summary>
    /// 如果添加类型，需要检查account相关的存储过程
    /// </summary>
    public class Action
    {
        public const string ALIPAY = "支付宝充值";
        public const string BANKUNION = "易宝PC支付";
        public const string YEEPAY = "易宝手机支付";
        public const string UPMP = "银联手机支付";
        public const string UPOP = "银联无卡支付";
        public const string PAYORDER = "支付订单";
        public const string REFOUND = "订单退款";//写错了,应该是refund
        public const string GIFTCARD = "使用充值卡";
        public const string GIVEMONEY = "充值送车费";
    }

    public enum SMSStatus
    {
        发送成功 = 0,
        发送失败 = 100,
        用户账号不存在或密码错误 = 101,
        账号已禁用 = 102,
        参数不正确 = 103,
        短信内容不正确 = 105,
        手机号码超过100个或合法的手机号码为空 = 106,
        余额不足 = 108,
        指定访问ip地址错误 = 109,
        短信内容存在系统保留关键词 = 110,
        模板短信序号不存在 = 114,
        短信签名标签序号不存在 = 115
    }
    public enum PayType
    {
        /// <summary>
        /// 收入
        /// </summary>
        Income = 1,
        /// <summary>
        /// 支出
        /// </summary>
        Pay = 0
    }

    public enum PayStatus
    {
        /// <summary>
        /// 已支付
        /// </summary>
        Paid = 1,
        /// <summary>
        /// 未支付(默认为未支付）
        /// </summary>
        unPaid = 0,

        /// <summary>
        /// 现金支付给司机
        /// </summary>
        CashPaying = 2,

        /// <summary>
        /// 现金支付完成
        /// </summary>
        CashPaid = 3
    }

    /// <summary>
    /// 车辆当前未知的枚举
    /// </summary>
    public enum CarLocation
    {
        /// <summary>
        /// 未知
        /// </summary>
        Unknown = 0,
        /// <summary>
        /// 在当前城市
        /// </summary>
        CurrentCity = 1,
        /// <summary>
        /// 即将到达
        /// </summary>
        AboutToArrive
    }
}
