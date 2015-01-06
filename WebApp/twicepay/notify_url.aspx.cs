using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using Com;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
using BLL;
using DBUtility;
using Model;
using Common;
namespace WebApp.twicepay
{
    public partial class notify_url : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分
                Dictionary<string, string> sPara = GetRequestPost();
                foreach (var item in sPara)
                {
                    new DBUtility.SqlDbHelper().Insert("insert into test values('" + item.Key + "','" + item.Value + "')", new SqlParameter[] { });
                }
                if (sPara.Count > 0)
                {

                    Notify aliNotify = new Notify();
                    bool verifyResult = aliNotify.VerifyNotify(sPara, Request.Form["sign"]);
                    if (verifyResult)
                    {
                        try
                        {
                            XmlDocument xmlDoc = new XmlDocument();
                            xmlDoc.LoadXml(sPara["notify_data"]);
                            string out_trade_no = xmlDoc.SelectSingleNode("/notify/out_trade_no").InnerText;
                            if (out_trade_no.Contains("_"))
                            {
                                out_trade_no = out_trade_no.Split('_')[0];
                            }
                            string trade_no = xmlDoc.SelectSingleNode("/notify/trade_no").InnerText;
                            string trade_status = xmlDoc.SelectSingleNode("/notify/trade_status").InnerText;
                            string total_fee = xmlDoc.SelectSingleNode("/notify/total_fee").InnerText;
                            string gmt_payment = xmlDoc.SelectSingleNode("/notify/gmt_payment").InnerText;
                            UserAccount objUser;
                            Model.Account objAccount = new Model.Account();
                            //DataTable dt = new OrderBLL().GetOrderById(out_trade_no);
                            Model.Orders order = new OrderBLL().GetModel(out_trade_no);

                            DataTable userAccount = new UserAccountBLL().GetDataTable(order.userID);
                            if (order.orderStatusID == 9)
                            {
                                if (trade_status == "TRADE_FINISHED" || trade_status == "TRADE_SUCCESS")
                                {
                                    objUser = new UserAccountBLL().GetMaster(order.userID);
                                    objAccount.userID = objUser.Id;
                                    int i = new UserAccountBLL().UpdateAccount(objUser.Id, decimal.Parse(total_fee), "add");
                                    if (i == 1)
                                    {
                                        objAccount.Action = Common.Action.ALIPAY;
                                        objAccount.Money = decimal.Parse(total_fee);
                                        objAccount.Type = PayType.Income;//充值(之后马上支付)
                                        objAccount.userID = order.userID;
                                        objAccount.Balance = objUser.Balance + decimal.Parse(total_fee);
                                        objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                                        new AccountBLL().InsertAccount(objAccount);
                                        int j = new UserAccountBLL().UpdateAccount(objUser.Id, order.unpaidMoney, "reduce");
                                        if (j != 0)
                                        {
                                            Model.CarInfo car = new BLL.CarInfoBLL().GetModel(order.carId);
                                            objAccount.Action = Common.Action.PAYORDER;//支付订单
                                            objAccount.Money = order.unpaidMoney;
                                            objAccount.Type = Common.PayType.Pay;
                                            objAccount.userID = order.userID;
                                            objAccount.Balance = objUser.Balance - order.unpaidMoney;
                                            objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                                            objAccount.OrderId = out_trade_no;
                                            new AccountBLL().InsertAccount(objAccount);
                                            int m = new OrderBLL().UpdateOrderInfo(6, out_trade_no, DateTime.Now.ToLocalTime());
                                            Common.SMS.user_SecondPaid(Math.Round(order.unpaidMoney, 2).ToString(), userAccount.Rows[0]["telphone"].ToString());//给下单人发短信
                                            Common.SMS.driver_OrderComplete(car.telPhone ,out_trade_no, car.telPhone);//给司机发短信
                                            if (order.SMSReceiver == 1 && userAccount.Rows[0]["telphone"].ToString() != order.passengerPhone)
                                            {
                                                Common.SMS.user_SecondPaid(Math.Round(order.unpaidMoney, 2).ToString(), userAccount.Rows[0]["telphone"].ToString());//给下单人发短信
                                                Common.SMS.user_SecondPaid(Math.Round(order.unpaidMoney, 2).ToString(), order.passengerPhone);//给乘车人发的
                                                Common.SMS.driver_OrderComplete(car.telPhone ,out_trade_no, car.telPhone);//给司机发短信
                                            }
                                            new BLL.DirverAccountBLL().PustMessageToDriver(car.Id, out_trade_no + "号订单已成功完成。");
                                            new RestrictBLL().addRestrict(order.userID, order.unpaidMoney);
                                            new BLL.UserAccountBLL().AddScore(order);
                                            Response.Write("success");
                                            Response.End();
                                        }
                                    }
                                }
                            }
                            else if (order.orderStatusID == (int)Common.OrderStatus.订单完成 || order.orderStatusID == (int)Common.OrderStatus.服务取消)
                            {
                                Response.Write("success");
                                Response.End();
                            }
                        }
                        catch (Exception exc)
                        {

                            Response.Write(exc.ToString());
                        }
                    }
                    else
                    {
                        Response.Write("fail");
                        Response.End();
                    }
                }
                else
                {
                    Response.Write("无通知参数");
                    Response.End();
                }
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }

        }
        public Dictionary<string, string> GetRequestPost()
        {
            try
            {
                int i = 0;
                Dictionary<string, string> sArray = new Dictionary<string, string>();
                NameValueCollection coll;
                coll = Request.Form;
                String[] requestItem = coll.AllKeys;

                for (i = 0; i < requestItem.Length; i++)
                {
                    sArray.Add(requestItem[i], Request.Form[requestItem[i]]);
                }
                return sArray;
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
                return null;
            }

        }
    }
}