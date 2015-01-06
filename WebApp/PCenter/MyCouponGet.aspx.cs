using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Common;
using IEZU.Log;

namespace WebApp.PCenter
{
    public partial class MyCouponGet : PageBase.PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form["Action"] == "Get")
            {
                Response.ContentType = "application/json";

                try
                {
                    if (Request.Form["SN"].ToString() == "")
                    {
                        Response.Write("{\"Message\":\"序列号不能为空！\"}");
                        return;
                    }
                    Model.Coupon Coup = BLL.Coupon.GetBySN(Request.Form["SN"].ToUpper());//根据Post参数获取优惠券
                    if (Coup != null)
                    {
                        //已绑定
                        if (Coup.userID != 0)
                        {
                            Response.Write("{\"Message\":\"该优惠券已被兑换过，如有疑问，请联系客服！\"}");
                            return;
                        }

                        //已过期
                        if (Coup.Deadline < DateTime.Now)
                        {
                            Response.Write("{\"Message\":\"该优惠券已过期，如有疑问，请联系客服！\"}");
                            return;
                        }

                        //已被使用
                        if (Coup.Status == 1)
                        {
                            Response.Write("{\"Message\":\"该优惠券已被使用，如有疑问，请联系客服！\"}");
                            return;
                        }

                        Coup.userID = userAccount.Id;
                        Coup.OrderId = "";
                        BLL.Coupon.Update(Coup);
                        LogHelper.WriteOperation("兑换优惠券[" + Coup.Sn + "]", OperationType.Update, "更新成功", Username);
                        Response.Write("{\"Message\":\"Complete\"}");
                    }
                    else
                    {
                            Response.Write("{\"Message\":\"不存在的优惠券！\"}");
                            LogHelper.WriteOperation("查询充值号为[" + Request.Form["SN"] + "]", OperationType.Query, "指定序列号的优惠券不存在", Username);

                    }
                }
                catch (Exception exception)
                {
                    Response.Write("{\"Message\":\"系统异常！\"}");
                }
                finally
                {
                    Response.End();
                }
            }
        }
    }
}