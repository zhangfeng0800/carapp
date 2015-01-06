using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// 优惠劵处理程序
    /// </summary>
    public class CouponHandler : IHttpHandler
    {
        private readonly Coupon _coupon = new Coupon();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "username":
                    context.Response.Write(GetUserName(context.Request.Form["userid"]));
                    break;
                case "UserCouponList":
                   UserCouponList(context);
                    break;;
            }
        }

        public string GetUserName(string userid)
        {
            var bll = new UserAccountBLL();
            var id = 0;
            if (int.TryParse(userid, out id))
            {
                var model = bll.GetModel(id);
                if (model == null)
                {
                    return "";
                }
                return model.Compname;
            }
            else
            {
                return "";
            }

        }
        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {

                string name = context.Request["Name"];
                int cost = Convert.ToInt32(context.Request["Cost"]);
                DateTime startdate = Convert.ToDateTime(context.Request["Startdate"]);
                DateTime deadline = Convert.ToDateTime(context.Request["Deadline"]);
                if (startdate > deadline)
                {
                    message.IsSuccess = false;
                    message.Message = "开始时间大于结束时间";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                decimal restrictions = Convert.ToDecimal(context.Request["Restrictions"]);
                if (restrictions > 100000)
                {
                    message.IsSuccess = false;
                    message.Message = "限制金额不能大于100000";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                int count = Convert.ToInt32(context.Request["count"]);
                if (count == 0)
                {
                    message.IsSuccess = false;
                    message.Message = "请输入大于0的数量";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                int hasCount = 0;
                if (count > 100)
                {
                    count = 100;
                }
                while (true)
                {
                    if (hasCount == count)
                    {
                        break;
                    }

                    string sn = GenerateUniqueText(6);
                    var model = new Model.Coupon()
                    {
                        Name = name,
                        Cost = cost,
                        userID = 0,
                        Sn = sn,
                        Startdate = startdate,
                        Deadline = deadline,
                        Status = 0,
                        Restrictions = restrictions
                    };

                    if (_coupon.IsExist(model.Sn))
                    {
                        LogHelper.WriteOperation("验证优惠券[" + sn + "]", OperationType.Query, "优惠券[" + sn + "]存在", HttpContext.Current.User.Identity.Name);
                        continue;
                    } 
                    Coupon.Add(model);
                    LogHelper.WriteOperation("添加优惠券[" + sn + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                    hasCount++;
                }
                message.IsSuccess = true;
                message.Message = "";
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
                message.Message = "生成失败，请检查参数";
                message.IsSuccess = false;
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            int status = string.IsNullOrEmpty(context.Request["status"]) ? 0 : Int32.Parse(context.Request["status"]);
            
            string compname = context.Request["compname"];
            
            string telphone = context.Request["telphone"];
            string couponname = context.Request["couponName"];
            //string order = context.Request["sort"] + " " + context.Request["order"];
            //if (order == " ")
            //{
            //    order = " id desc ";
            //}

            //string where = string.Empty;
            //if (!string.IsNullOrEmpty(status))
            //{
            //    where = "Status = " + status;
            //}

            //var list = _coupon.GetList(pageIndex, pageSize, order, where, out count);
            var list = _coupon.GetPageListPro(status, compname, telphone,couponname, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
        }
        private void UserCouponList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var userid = int.Parse(context.Request["id"].ToString());
            
            var list = _coupon.GetPageListPro(userid, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
        }
        public string GenerateUniqueText(int num)
        {
            string randomResult = string.Empty;
            string readyStr = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            char[] rtn = new char[num];
            Guid gid = Guid.NewGuid();
            var ba = gid.ToByteArray();
            for (var i = 0; i < num; i++)
            {
                rtn[i] = readyStr[((ba[i] + ba[num + i]) % 35)];
            }
            foreach (char r in rtn)
            {
                randomResult += r;
            }
            return randomResult;
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