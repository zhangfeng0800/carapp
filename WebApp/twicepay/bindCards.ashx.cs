using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using BLL;
using Model;
namespace WebApp.twicepay
{
    /// <summary>
    /// bindCards 的摘要说明
    /// </summary>
    public class bindCards : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ContentType = "text/plain";
                if (context.Request.Params["handlePay"] != null)
                {
                    string orderId = context.Request.Params["orderId"].ToString();
                    DataTable dt = new OrderBLL().GetOrderById(orderId);
                    DataTable userAccount = new UserAccountBLL().GetDataTable(Convert.ToInt32(dt.Rows[0]["userID"]));
                    UserAccount objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    if (context.Request.Params["IsUse"].ToString() == "use")//使用账户余额
                    {
                        string userPwd = context.Request.Params["userPwd"].ToString();
                        //if (userAccount.Rows[0]["password"].ToString() == Common.EncryptAndDecrypt.Encrypt(userPwd))
                        if (new BLL.UserAccountBLL().EnterPayPassword(Convert.ToInt32(dt.Rows[0]["userID"]),userPwd))
                        {
                            if (objUser.Balance >= decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()))
                            {
                                context.Response.Write("payok");
                                context.Response.End();
                            }
                            else
                            {
                                string paystyle = context.Request.Params["paystyle"].ToString();
                                if (paystyle == "")
                                {
                                    context.Response.Write("balanceNo");
                                    context.Response.End();
                                }
                                else
                                {
                                    context.Response.Write("payok");
                                    //context.Response.End();
                                }
                            }
                        }
                        else
                        {
                            context.Response.Write("pwdError");
                            context.Response.End();
                        }
                    }
                    else
                    {
                        context.Response.Write("payok");
                        context.Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}