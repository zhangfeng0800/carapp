using System;
using System.Linq;
using System.Net.Configuration;
using System.Text;
using System.Net;
using System.IO;
using System.Collections.Specialized;
using System.Xml;
using System.Security.Cryptography;
using System.Collections.Generic;

namespace Common
{
    public class SMS
    {
        public static string PostUrl = "http://mssms.cn:8000/msm/sdk/http/sendsmsutf8.jsp?";//短信接口的发送地址

        /// <summary>
        /// 注册用户SMS-000
        /// </summary>
        /// <param name="VerifyCode">验证码</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_Register(string verifyCode, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("verifyCode", verifyCode);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserRegister.ToString(),dict);



            //return MessageSender(VerifyCode, mobile, SMSTemp.UserRegister);
        }

        /// <summary>
        /// 修改手机号码SMS-001
        /// </summary>
        /// <param name="VerifyCode">验证码</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_ChangeMobile(string verifyCode, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("verifyCode", verifyCode);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserChangeMobile.ToString(), dict);
            //return MessageSender(VerifyCode, mobile, SMSTemp.UserChangeMobile);
        }

        public static bool ResetPayPassword(string name, string paypassword, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("name", name);
            dict.Add("paypassword", paypassword);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.ResetPayPassword.ToString(), dict);
            // return MessageSender(name + "," + paypassword, mobile, SMSTemp.ResetPayPassword);
        }
        /// <summary>
        /// 设置密码(找回密码)SMS-002
        /// </summary>
        /// <param name="VerifyCode">验证码</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_ChangePassword(string verifyCode, string type, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("verifyCode", verifyCode);
            dict.Add("type", type);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserChangePassword.ToString(), dict);
            //return MessageSender(VerifyCode + "," + Type, mobile, SMSTemp.UserChangePassword);
        }

        /// <summary>
        /// 创建用户SMS-003
        /// </summary>
        /// <param name="ParentUserName">创建者姓名</param>
        /// <param name="Password">密码</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CreateNewUser(string parentUserName, string password, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("parentUserName", parentUserName);
            dict.Add("password", password);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCreateNewUser.ToString(), dict);
            //return MessageSender(ParentUserName.Replace(',', '，') + "," + Password, mobile, SMSTemp.UserCreateNewUser);
        }
        /// <summary>
        /// 通过呼叫中心注册的短信
        /// </summary>
        /// <param name="password"></param>
        /// <param name="payPassword"></param>
        /// <param name="telphone"></param>
        /// <returns></returns>
        public static bool RegisterByMobile(string password, string payPassword, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("password", password);
            dict.Add("payPassword", payPassword);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.RegisterByMobile.ToString(), dict);
            //return MessageSender(password + "," + payPassword, telphone, SMSTemp.RegisterByMobile);
        }
        /// <summary>
        /// 订单确认SMS-005
        /// </summary>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_OrderConfirm(string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserOrderConfirm.ToString(), dict);
            //return MessageSender("", mobile, SMSTemp.UserOrderConfirm);
        }

        /// <summary>
        /// 派车完成SMS-010
        /// </summary>
        /// <param name="dateTime">出发时间</param>
        /// <param name="address">出发地点</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CarSetted(string dateTime, string address, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("dateTime", dateTime);
            dict.Add("address", address);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCarSetted.ToString(), dict);
           // return MessageSender(dateTime + "," + address, mobile, SMSTemp.UserCarSetted);
        }

        /// <summary>
        /// 车已出发_乘车人_SMS-015
        /// </summary>
        /// <param name="DriverMobile">司机电话</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CarLeaveForPassenger(string startAddress, string carNo, string driverName, string driverMobile, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("startAddress", startAddress);
            dict.Add("carNo", carNo);
            dict.Add("driverName", driverName);
            dict.Add("driverMobile", driverMobile);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCarLeaveForPassenger.ToString(), dict);
            //return MessageSender(StartAddress.Replace(',', '，') + "," + carNo + "," + drivername + "," + DriverMobile, mobile, SMSTemp.UserCarLeaveForPassenger);
        }

        /// <summary>
        /// 车已出发_下单人_SMS-016
        /// </summary>
        /// <param name="StartAddress">出发地址</param>
        /// <param name="DriverMobile">司机电话</param>
        /// <param name="passengerName">乘车人名称</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CarLeave(string startAddress, string carNo, string driverName, string driverMobile, string passengerName, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("startAddress", startAddress);
            dict.Add("carNo", carNo);
            dict.Add("driverName", driverName);
            dict.Add("driverMobile", driverMobile);
            dict.Add("passengerName", passengerName);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCarLeave.ToString(), dict);
           // return MessageSender(startAddress.Replace(',', '，') + "," + carNo + "," + driverName + "," + driverMobile + "," + passengerName.Replace(',', '，'), mobile, SMSTemp.UserCarLeave);
        }

        /// <summary>
        /// 车已就位_乘车人_SMS-020
        /// </summary>
        /// <param name="carBrand">汽车品牌</param>
        /// <param name="carNO">车牌号</param>
        /// <param name="DriverMobile">司机手机</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CarArrivalForPassenger(string carBrand, string carNo, string driverMobile, string driverName, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("carBrand", carBrand);
            dict.Add("carNo", carNo);
            dict.Add("driverMobile", driverMobile);
            dict.Add("driverName", driverName);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCarArrivalForPassenger.ToString(), dict);
            //return MessageSender(carBrand.Replace(',', '，') + "," + carNO + "," + driverName + "," + DriverMobile, mobile, SMSTemp.UserCarArrivalForPassenger);
        }

        /// <summary>
        /// 车已就位_下单人_SMS-021
        /// </summary>
        /// <param name="carBrand">汽车品牌</param>
        /// <param name="carNO">车牌号</param>
        /// <param name="startAddress">出发地址</param>
        /// <param name="passengerName">乘车人姓名</param>
        /// <param name="driverMobile">司机手机</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_CarArrival(string carBrand, string carNo, string startAddress, string passengerName, string driverName, string driverMobile, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("carBrand", carBrand);
            dict.Add("carNo", carNo);
            dict.Add("startAddress", startAddress);
            dict.Add("passengerName", passengerName);
            dict.Add("driverName", driverName);
            dict.Add("driverMobile", driverMobile);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserCarArrival.ToString(), dict);
            //return MessageSender(carBrand.Replace(',', '，') + "," + carNO + "," + startAddress + "," + passengerName + "," + drivername + "," + driverMobile, mobile, SMSTemp.UserCarArrival);
        }

        public static bool OrderRefound(string orderid, string money, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("orderid", orderid);
            dict.Add("money", money);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.RefoundMoney.ToString(), dict);
            //return MessageSender(orderid + "," + money, driverMobile, SMSTemp.RefoundMoney);
        }
        /// <summary>
        /// 二次付款_下单人_SMS-025
        /// </summary>
        /// <param name="totalMinut">总分钟</param>
        /// <param name="totalKm">总里程</param>
        /// <param name="overMinut">超分钟</param>
        /// <param name="overKM">超里程</param>
        /// <param name="overMinutMoney">超时费</param>
        /// <param name="overKMMoney">超里程费</param>
        /// <param name="highwayMoney">高速费</param>
        /// <param name="carStopMoney">停车费</param>
        /// <param name="airportMoney">机场费</param>
        /// <param name="emptyCarMoney">空驶费</param>
        /// <param name="secondPayMoney">二次付款总额</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_SecondPayNeed(string totalMinut, string totalKm, string overMinut, string overKM, string overMinutMoney, string overKMMoney, string highwayMoney, string carStopMoney, string airportMoney, string emptyKm, string emptyCarMoney, string endemptykm, string endemptyfee, string secondPayMoney, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("totalMinut", totalMinut);
            dict.Add("totalKm", totalKm);
            dict.Add("overMinut", overMinut);
            dict.Add("overKM", overKM);
            dict.Add("overMinutMoney", overMinutMoney);
            dict.Add("overKMMoney", overKMMoney);
            dict.Add("highwayMoney", highwayMoney);
            dict.Add("carStopMoney", carStopMoney);
            dict.Add("airportMoney", airportMoney);
            dict.Add("emptyKm", emptyKm);
            dict.Add("emptyCarMoney", emptyCarMoney);
            dict.Add("endemptykm", endemptykm);
            dict.Add("endemptyfee", endemptyfee);
            dict.Add("secondPayMoney", secondPayMoney);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPayNeed.ToString(), dict);
            //return MessageSender(totalMinut + "," + totalKm + "," + overMinut + "," + overKM + "," + overMinutMoney + "," + overKMMoney + "," + highwayMoney + "," + carStopMoney + "," + airportMoney + "," + emptyKm + "," + emptyCarMoney + "," + endemptykm + ',' + endemptyfee + ',' + secondPayMoney, mobile, SMSTemp.UserSecondPayNeed);
        }
        public static bool TwicePayNeed(string totalMinut, string totalKm, string overMinut, string overKM, string overMinutMoney, string overKMMoney, string highwayMoney, string carStopMoney, string airportMoney, string emptyKm, string emptyCarMoney, string endemptykm, string endemptyfee,string otherMoney, string secondPayMoney, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("totalMinut", totalMinut);
            dict.Add("totalKm", totalKm);
            dict.Add("overMinut", overMinut);
            dict.Add("overKM", overKM);
            dict.Add("overMinutMoney", overMinutMoney);
            dict.Add("overKMMoney", overKMMoney);
            dict.Add("highwayMoney", highwayMoney);
            dict.Add("carStopMoney", carStopMoney);
            dict.Add("airportMoney", airportMoney);
            dict.Add("emptyKm", emptyKm);
            dict.Add("emptyCarMoney", emptyCarMoney);
            dict.Add("endemptykm", endemptykm);
            dict.Add("endemptyfee", endemptyfee);
            dict.Add("otherMoney", otherMoney);
            dict.Add("secondPayMoney", secondPayMoney);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.TwicePayNeed.ToString(), dict);
            //return MessageSender(totalMinut + "," + totalKm + "," + overMinut + "," + overKM + "," + overMinutMoney + "," + overKMMoney + "," + highwayMoney + "," + carStopMoney + "," + airportMoney + "," + emptyKm + "," + emptyCarMoney + "," + endemptykm + ',' + endemptyfee + ',' + secondPayMoney, mobile, SMSTemp.TwicePayNeed);
        }
        public static bool UsePayByAccount(string unpaidMoney, string nowBalance, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("unpaidMoney", unpaidMoney);
            dict.Add("nowBalance", nowBalance);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.PayByAccount.ToString(), dict);
            //return MessageSender(unpaidMoney + "," + nowBalance, mobile, SMSTemp.PayByAccount);
        }



        /// <summary>
        /// 二次付款通知_乘车人_SMS-026
        /// </summary>
        /// <param name="totalMinut">总分钟</param>
        /// <param name="totalKm">总里程</param>
        /// <param name="overMinut">超分钟</param>
        /// <param name="overKM">超里程</param>
        /// <param name="overMinutMoney">超时费</param>
        /// <param name="overKMMoney">超里程费</param>
        /// <param name="highwayMoney">高速费</param>
        /// <param name="carStopMoney">停车费</param>
        /// <param name="airportMoney">机场费</param>
        /// <param name="emptyCarMoney">空驶费</param>
        /// <param name="secondPayMoney">二次付款总额</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_SecondPayNeedForPassenger(string totalMinut, string totalKm, string overMinut, string overKM, string overMinutMoney, string overKMMoney, string highwayMoney, string carStopMoney, string airportMoney, string emptyKm, string emptyCarMoney, string endemptykm, string endemptyfee, string otherMoney, string secondPayMoney, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("totalMinut", totalMinut);
            dict.Add("totalKm", totalKm);
            dict.Add("overMinut", overMinut);
            dict.Add("overKM", overKM);
            dict.Add("overMinutMoney", overMinutMoney);
            dict.Add("overKMMoney", overKMMoney);
            dict.Add("highwayMoney", highwayMoney);
            dict.Add("carStopMoney", carStopMoney);
            dict.Add("airportMoney", airportMoney);
            dict.Add("emptyKm", emptyKm);
            dict.Add("emptyCarMoney", emptyCarMoney);
            dict.Add("endemptykm", endemptykm);
            dict.Add("endemptyfee", endemptyfee);
            dict.Add("otherMoney", otherMoney);
            dict.Add("secondPayMoney", secondPayMoney);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPayNeedForPassenger.ToString(), dict);
            //return MessageSender(totalMinut + "," + totalKm + "," + overMinut + "," + overKM + "," + overMinutMoney + "," + overKMMoney + "," + highwayMoney + "," + carStopMoney + "," + airportMoney + "," + emptyKm + "," + emptyCarMoney + "," + secondPayMoney, mobile, SMSTemp.UserSecondPayNeedForPassenger);
        }

        /// <summary>
        /// 二次付款完成SMS-030
        /// </summary>
        /// <param name="Money">二次付款费用</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_SecondPaid(string money, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("money", money);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPaid.ToString(), dict);
            //return MessageSender(Money, mobile, SMSTemp.UserSecondPaid);
        }
        /// <summary>
        /// 二次付款完成SMS-089
        /// </summary>
        /// <param name="Money">二次付款费用并返回订单信息</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_SecondPaidSuccess(string unpaidMoney, string passengerName, string carUseName, string startAddress, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("unpaidMoney", unpaidMoney);
            dict.Add("passengerName", passengerName);
            dict.Add("carUseName", carUseName);
            dict.Add("startAddress", startAddress);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPaidSucess.ToString(), dict);
            //return MessageSender(content, mobile, SMSTemp.UserSecondPaidSucess);
        }


        /// <summary>
        /// 无需二次付款SMS-035
        /// </summary>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_SecondPayUnneed(string passengerName,string carUseName,string startAddress,string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("passengerName", passengerName);
            dict.Add("carUseName", carUseName);
            dict.Add("startAddress", startAddress);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPayUnneed.ToString(), dict);
            //return MessageSender("", mobile, SMSTemp.UserSecondPayUnneed);
        }

        /// <summary>
        /// 取消订单无需退款SMS-040 () 
        /// </summary>
        /// <param name="mobile"></param>
        /// <returns></returns>
        public static bool user_OrderCancelNoPay(string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserOrderCancelNoPay.ToString(), dict);
            //return true; //MessageSender("", mobile, SMSTemp.user_OrderCancelNoPay);
        }

        /// <summary>
        /// 取消订单无需退款SMS-045
        /// </summary>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_OrderCancelAndPay(string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserOrderCancelAndPay.ToString(), dict);
            //return MessageSender("", mobile, SMSTemp.UserOrderCancelAndPay);
        }
        /// <summary>
        /// 未付款订单直接取消
        /// </summary>
        /// <param name="mobile"></param>
        /// <returns></returns>
        public static bool NoPayOrderCancel(string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.NoPayOrderCancel.ToString(), dict);
        }


        /// <summary>
        /// 司机获取新订单SMS-050
        /// </summary>
        /// <param name="carNO">车牌号</param>
        /// <param name="carUseWay">用车方式</param>
        /// <param name="startCity">出发城市</param>
        /// <param name="overCity">目的城市</param>
        /// <param name="departrueTime">出发时间</param>
        /// <param name="passengerName">乘车人姓名</param>
        /// <param name="passengerPhone">乘车人电话</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool driver_GetOrder(string carNO, string carUseWay, string startCity, string overCity, string departrueTime, string passengerName, string passengerPhone, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("carNO", carNO);
            dict.Add("carUseWay", carUseWay);
            dict.Add("startCity", startCity);
            dict.Add("overCity", overCity);
            dict.Add("departrueTime", departrueTime);
            dict.Add("passengerName", passengerName);
            dict.Add("passengerPhone", passengerPhone);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.DriverGetOrder.ToString(), dict);
            //return MessageSender(carNO + "," + carUseWay.Replace(',', '，') + "," + startCity.Replace(',', '，').Replace('&', ' ') + "," + overCity.Replace(',', '，').Replace('&', ' ') + "," + departrueTime + "," + passengerName.Replace(',', '，') + "," + passengerPhone, mobile, SMSTemp.DriverGetOrder);
        }

        /// <summary>
        /// 司机车已就位SMS-055
        /// </summary>
        /// <param name="careNO">车牌号</param>
        /// <param name="passengerName">乘车人姓名</param>
        /// <param name="passengerPhone">乘车人电话</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool driver_CarArrival(string driverName, string passengerName, string passengerPhone, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("driverName", driverName);
            dict.Add("passengerName", passengerName);
            dict.Add("passengerPhone", passengerPhone);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.DriverCarArrival.ToString(), dict);
            //return MessageSender(careNO + "," + passengerName.Replace(',', '，') + "," + passengerPhone, mobile, SMSTemp.DriverCarArrival);
        }

        /// <summary>
        /// 订单完成SMS-060
        /// </summary>
        /// <param name="carNO">车牌号</param>
        /// <param name="orderID">订单ID</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool driver_OrderComplete(string carNO, string orderID, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("carNO", carNO);
            dict.Add("orderID", orderID);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.DriverOrderComplete.ToString(), dict);
            //return MessageSender(carNO + "," + orderID, mobile, SMSTemp.DriverOrderComplete);
        }

        /// <summary>
        /// 订单取消SMS-065
        /// </summary>
        /// <param name="carNO">车牌号</param>
        /// <param name="orderID">订单ID</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool driver_OrderCancel(string carNO, string orderID, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("carNO", carNO);
            dict.Add("orderID", orderID);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.DriverOrderCancel.ToString(), dict);
            //return MessageSender(carNO + "," + orderID, mobile, SMSTemp.DriverOrderCancel);
        }

        /// <summary>
        /// 发票已邮寄SMS-070
        /// </summary>
        /// <param name="userCompName">用户真实姓名</param>
        /// <param name="orderID">订单编号</param>
        /// <param name="address">邮寄地址</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool user_InvoicePosted(string userCompName, string orderID, string address, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("userCompName", userCompName);
            dict.Add("orderID", orderID);
            dict.Add("address", address);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserInvoicePosted.ToString(), dict);
            //return MessageSender(userCompName.Replace(',', '，') + "," + orderID + "," + address.Replace(',', '，'), mobile, SMSTemp.UserInvoicePosted);
        }

        /// <summary>
        /// 通知客服有订单
        /// </summary>
        /// <param name="orderTime">下单时间</param>
        /// <param name="mobile">手机号码</param>
        /// <returns></returns>
        public static bool servicer_OrderNotice(string orderTime, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("orderTime", orderTime);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.ServicerOrderNotice.ToString(), dict);
            //return MessageSender(orderTime, mobile, SMSTemp.ServicerOrderNotice);
        }
        /// <summary>
        /// 用户注册成功后发送随机支付密码
        /// </summary>
        /// <param name="name"></param>
        /// <param name="paypwd"></param>
        /// <param name="mobile"></param>
        /// <returns></returns>
        public static bool sendUserPaypwd(string name, string paypwd, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("name", name);
            dict.Add("paypwd", paypwd);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.SendUserPaypwd.ToString(), dict);
            //return MessageSender(name + "," + paypwd, mobile, SMSTemp.SendUserPaypwd);
        }
        public static bool FindLoginPwd(string checkcode, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("checkcode", checkcode);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.FindLoginPassword.ToString(), dict);
            //return MessageSender(checkcode, mobile, SMSTemp.FindLoginPassword);
        }

        public static bool ResendCar(string dateTime, string address, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("dateTime", dateTime);
            dict.Add("address", address);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.ResendCar.ToString(), dict);
            //return MessageSender(dateTime + "," + address, mobile, SMSTemp.ResendCar);
        }
        public static bool InformationToFormerDriver(string dateTime, string address, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("dateTime", dateTime);
            dict.Add("address", address);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.InformationToFormerDriver.ToString(), dict);
            //return MessageSender(dateTime + "," + address, mobile, SMSTemp.InformationToFormerDriver);
        }
        public static bool sendEditOrder(string orderID, string startAddress,string arriveAddress, string departureTime, string passengerName, string passengerPhone, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("orderID", orderID);
            dict.Add("startAddress", startAddress);
            dict.Add("arriveAddress", arriveAddress);
            dict.Add("departureTime", departureTime);
            dict.Add("passengerName", passengerName);
            dict.Add("passengerPhone", passengerPhone);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.SendEditOrder.ToString(), dict);
            //return MessageSender(messageContent, mobile, SMSTemp.SendEditOrder);
        }

        public static bool DriverOrderComplete(string driverName,string orderID,string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("orderID", orderID);
            dict.Add("driverName", driverName);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.DriverOrderComplete.ToString(), dict);
        }

        /// <summary>
        /// 二次付款账户余额足够，直接扣款
        /// </summary>
        /// <returns></returns>
        public static bool UserSecondPaidUneed(string passengerName, string caruserway, string startAddress, string totalmoney, string leftbalance, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("passengerName", passengerName);
            dict.Add("caruserway", caruserway);
            dict.Add("startAddress", startAddress);
            dict.Add("totalmoney", totalmoney);
            dict.Add("leftbalance", leftbalance);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserSecondPaidUneed.ToString(), dict);
        }

        public static bool UserKefuPwd(string compname, string password, string mobile)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("compname", compname);
            dict.Add("password", password);
            dict.Add("mobile", mobile);
            return ServiceHelper.SendSms(mobile, SMSTemp.UserKefuPwd.ToString(), dict);
        }

      
        /// <summary>
        /// 短信发送[模板形式]
        /// </summary>
        /// <param name="messageCont">内容[用例:"参数1,参数2,参数3"]</param>
        /// <param name="mobile">手机号码</param>
        /// <param name="tempId">模板标志</param>
        /// <returns></returns>
        public static bool MessageSender(string messageCont, string mobile, SMSTemp TempType)
        {
            /*
             * 短信平台网址 http://www.mssms.cn
             * 可以打开以上网址，登录短信平台查看短信的发送记录或设置模板，如果有问题，请联系讨论组的客服人员
             */
            string account = "JSMB260253";//短信平台登录账号
            string password = "432085";//短信平台登录密码，如果修改了短信平台的登录密码，切记一定要修改这里
            string tempid = "SMS-";//模板号前缀，比如模板全称：SMS-00、SMS-01、SMS-02等，如果新增短信模板也请使用该前缀
            string[] strArray = new string[0];
            int intTempType = Convert.ToInt32(TempType);
            if (intTempType.ToString().Length < 3)
            {
                strArray = new string[3 - intTempType.ToString().Length];
                for (int i = 0, max = strArray.Length; i < max; i++)
                    strArray[i] = "0";
            }
            tempid += string.Join("", strArray) + intTempType.ToString();//如果短信模板编号长度不足3位，补足为3位，比如50补足为050，7补足为007。

            string postStrTpl = "username={0}&scode={1}&content={2}&tempid={3}&mobile={4}";

            string[] queryStrArray = messageCont.Split(',');//将传递的参数值转换成@x@=xxx的形式
            StringBuilder sbContent = new StringBuilder("");
            for (int i = 0, max = queryStrArray.Length; i < max; i++)
            {
                sbContent.Append("@" + (i + 1) + "@=" + queryStrArray[i] + ",");
            }
            if (sbContent.Length > 0)//如果字符串长度不为0，把最后一位字符（就是,浮号）去掉
                sbContent.Remove(sbContent.Length - 1, 1);

            bool result = false;//结果是否成功
            try
            {
                UTF8Encoding encoding = new UTF8Encoding();
                byte[] postData = encoding.GetBytes(string.Format(postStrTpl, account, password, sbContent.ToString(), tempid, mobile));

                HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(PostUrl);//建立请求实例
                myRequest.Method = "POST";
                myRequest.ContentType = "application/x-www-form-urlencoded;charset=UTF-8";
                myRequest.ContentLength = postData.Length;

                Stream newStream = myRequest.GetRequestStream();
                // Send the data.
                newStream.Write(postData, 0, postData.Length);
                newStream.Flush();
                newStream.Close();

                HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse(); //获取服务器请求的结果
                if (myResponse.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader reader = new StreamReader(myResponse.GetResponseStream(), Encoding.UTF8);
                    string ReturnValueStr = reader.ReadToEnd().ToString().Replace("\r", "").Replace("\n", "").Replace(" ", "");
                    if (ReturnValueStr.Length > 0 && ReturnValueStr[0] == '0')//提交成功格式:0#数字#数字
                    {
                        result = true;
                    }
                    else if (ReturnValueStr.StartsWith("110"))
                    {
                        result = false;
                    }
                }
                else
                {
                    //访问失败
                    result = false;
                }
            }
            catch (Exception e)
            {
                Common.Logger.Fatal(e);
            }

            return result;
        }
       
    }
}
