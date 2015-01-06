using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Com.UnionPay.Upmp;
using System.Collections.Specialized;
using BLL;
using Model;
using System.Data;
using Common;
using System.Data.SqlClient;

namespace WebApp.twicepay
{
    public partial class UPMPcallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分
                Dictionary<String, String> para = new Dictionary<String, String>();
                NameValueCollection coll;
                coll = Request.Form;
                String[] requestItem = coll.AllKeys;

                for (int i = 0; i < requestItem.Length; i++)
                {
                    para.Add(requestItem[i], Request.Form[requestItem[i]]);
                }

                //DBUtility.SqlDbHelper Helper = new DBUtility.SqlDbHelper();
                //SqlParameter[] datas =
                //{
                //    new SqlParameter("@key","银联"),
                //    new SqlParameter("@value","收到啊" )
                //};
                //Helper.Insert("insert into test values(@key,@value)", datas);


                if (para.Count > 0)
                {
                    if (UpmpService.VerifySignature(para))
                    {// 服务器签名验证成功
                        //请在这里加上商户的业务逻辑程序代码
                        //获取通知返回参数，可参考接口文档中通知参数列表(以下仅供参考)
                        String transStatus = Request.Form["transStatus"];// 交易状态

                        if ("" != transStatus && "00" == transStatus)
                        {

                            string out_trade_no = para["orderNumber"].ToString().Substring(0, para["orderNumber"].ToString().Length - 2);
                            decimal total_fee = Convert.ToDecimal(para["settleAmount"]) / 100; //银联是以 分 为最小单位


                            UserAccount objUser;
                            Model.Account objAccount = new Model.Account();
                            DataTable dt = new OrderBLL().GetOrderById(out_trade_no);
                            DataTable userAccount = new UserAccountBLL().GetDataTable(Convert.ToInt32(dt.Rows[0]["userID"]));
                            if (Convert.ToInt32(dt.Rows[0]["orderStatusID"]) == 9)
                            {
                                objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                                objAccount.userID = objUser.Id;
                                int i = new UserAccountBLL().UpdateAccount(objUser.Id, total_fee, "add");
                                if (i == 1)
                                {
                                    objAccount.Action = Common.Action.UPMP;//充值(之后马上支付)
                                    objAccount.Money = total_fee;
                                    objAccount.Type = PayType.Income;
                                    objAccount.userID = Convert.ToInt32(dt.Rows[0]["userID"]);
                                    objAccount.Balance = objUser.Balance + total_fee;
                                    objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                                    new AccountBLL().InsertAccount(objAccount);
                                    int j = new UserAccountBLL().UpdateAccount(objUser.Id, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()), "reduce");
                                    if (j != 0)
                                    {
                                        Model.CarInfo car = new BLL.CarInfoBLL().GetModel(dt.Rows[0]["carId"].ToString());
                                        objAccount.Action = Common.Action.PAYORDER;//支付订单
                                        objAccount.Money = decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                                        objAccount.Type = Common.PayType.Pay;
                                        objAccount.userID = Convert.ToInt32(dt.Rows[0]["userID"]);
                                        objAccount.Balance = objUser.Balance + total_fee - decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                                        objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                                        objAccount.OrderId = out_trade_no;
                                        new AccountBLL().InsertAccount(objAccount);
                                        int m = new OrderBLL().UpdateOrderInfo(6, out_trade_no, DateTime.Now.ToLocalTime());
                                        Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), userAccount.Rows[0]["telphone"].ToString());//给下单人发短信
                                        Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), dt.Rows[0]["passengerPhone"].ToString());//给乘车人发的
                                        Common.SMS.driver_OrderComplete(car.telPhone ,out_trade_no, car.telPhone);//给司机发短信
                                        new BLL.DirverAccountBLL().PustMessageToDriver(car.Id, out_trade_no + "号订单已成功完成。");
                                        new RestrictBLL().addRestrict(Convert.ToInt32(dt.Rows[0]["userID"]), decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                                        new BLL.UserAccountBLL().AddScore(Common.DataTableToList.List<Model.Orders>(dt).FirstOrDefault());
                                        Response.Write("success");
                                        Response.End();
                                    }
                                }
                            }
                        }
                    }
                }
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
          
        }
    }
}