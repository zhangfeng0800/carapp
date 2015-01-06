using System;
using BLL.HandlePayUtilBll;
using DAL.PayUtil;
using IEZU.Log;
using Model;
using BLL;
using System.Data;
using Com.Alipay;
using System.Web.Configuration;
namespace WebApp
{
    public partial class HandleOrderPay : System.Web.UI.Page
    {
        public UserAccount user;

        #region 银联无卡支付字段代码
        public string MerId = "";
        public string OrderId = "";//订单编号16位长度
        public string Amount = "";//金额12位长度，左端补0
        public string CuryId = "";//订单交易币种.人民币156
        public string Date = "";//订单时间，格式：YYYYMMDD
        public string BackUrl = WebConfigurationManager.AppSettings["paybackUrl"] + "/UpopCallback.aspx";
        public string SignStr = "";
        public string Idext = "";
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserInfo"] == null)
            {
                Response.Redirect("/Login.aspx");
                return;
            }
            user = Session["UserInfo"] as UserAccount;
            if (!IsPostBack)
            {
                if (Request.Form["orderpay"] != null && Request.Form["payType"] != null && Request.Form["addMo"] != null && Request.Form["wgId"] != null && Request.Form["style"] != null)
                {
                    string payType = Request.Form["payType"];
                    string orderId = Request.Form["orderpay"];
                    var addMo = Request.Form["addMo"];
                    string wgId = Request.Form["wgId"];
                    string style = Request.Form["style"];
                    HanlePay(payType, orderId, addMo, wgId, style);
                }
            }
        }

        public void HanlePay(string payType, string orderId, string iscomposite, string wgid, string style)
        {
            string serviceInfo = "";
            string money = "";
            int yepaayId = 1;
            var handbll = new HandlePayBLL();
            int isenough = 0;
            try
            {
                handbll.HandlePay(orderId, style, iscomposite, out money, out serviceInfo, out yepaayId, out isenough);
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                Response.Write(exception.Message);
               Response.End();
            } 
            if (iscomposite == "y" && isenough == 1)
            {
                Response.Write("账户余额充足");
                Response.End();
            }

            if (payType == "unionpay") //银联支付
            {
                HanleUpopPay(style, orderId, money);
                return;
            }

            if (wgid.Trim().Length > 0) //易宝
            {
                yeepaySubmit ys = new yeepaySubmit();
                ys.GoToPay(orderId + "_" + yepaayId, money, wgid, serviceInfo, style);

            }
            else //支付宝
            {
                Submit sb = new Submit();
                sb.GoToPay(orderId, money, "1", serviceInfo, style);
            }
        }


        #region 银联支付代码
        public void HanleUpopPay(string style, string orderID, string money)
        {
            NetPay netpay = new NetPay();
            string path = Server.MapPath("App_Data/MerPrK_808080201304188_20140618154302.key");
            MerId = "808080201304188";
            netpay.buildKey(MerId, 0, path);
            if (netpay.PrivateKeyFlag)
            {
                if (style.Equals("order")) //支付订单
                {
                    orderID = "00" + orderID; //支付订单
                    OrderId = orderID.Substring(0, 16);
                    Idext = orderID.Substring(16);
                }
                else
                {
                    orderID = "01" + orderID; //充值
                    OrderId = orderID.Substring(0, 16);
                    Idext = orderID.Substring(16);
                }
                Amount = Convert.ToInt32(Convert.ToDecimal(money) * 100).ToString(); //要求为12位，不够的左端补0;
                if (Amount.Length < 12)
                {
                    int num = 12 - Amount.Length;
                    string zero = "";
                    for (int i = 0; i < num; i++)
                    {
                        zero += "0";
                    }
                    Amount = zero + Amount;
                }
                CuryId = "156";
                Date = DateTime.Now.ToString("yyyyMMdd");
                SignStr = netpay.Sign(MerId + OrderId + Amount + CuryId + Date + "0001" + Idext);
            }

        }
        #endregion


    }
}