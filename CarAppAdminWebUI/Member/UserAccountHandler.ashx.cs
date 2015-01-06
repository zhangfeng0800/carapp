using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// UserAccountHandler 的摘要说明
    /// </summary>
    public class UserAccountHandler : IHttpHandler
    {
        private readonly UserAccountBLL _userAccountBll = new UserAccountBLL();
        private readonly AccountBLL _accountBll = new AccountBLL();
        private readonly OrderBLL _orderBll = new OrderBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "list":
                    List(context);
                    break;
                case "logaccountlist":
                    LogAccountList(context);
                    break;
                case "logorderlist":
                    LogOrderList(context);
                    break;
                case "repassword":
                    RePassword(context);
                    break;
                case "cancelPermission": cancelPermission(context); break;
                case "rechargeMoney":
                    rechargeMoney(context); break;
                case "changeHideFunding":
                    changeHideFunding(context);
                    break;
                case "getGiftCard":
                    getGiftCard(context);
                    break;
                case "levelUser":
                    levelUser(context);
                    break;
                case "changeBlack":
                    changeBlack(context);
                    break;
                case "changevipstatus":
                    ChangeStatus(context);
                    break;
                case "getuserinfo":  //用户转账页面获取用户信息
                    GetUserInfo(context);
                        break;
                case "transmoney":
                        Transmoney(context);//用户转账操作
                        break; 
                case "getTransInfo":
                        GetTransInfo(context);
                        break;
            }
        }

        private void GetTransInfo(HttpContext context)
        {
            try
            {
                var transId = context.Request["transId"];
                var data = new BLL.AccountBLL().GetTransData(Int32.Parse(transId));
                context.Response.Write((JsonConvert.SerializeObject(data)));
            }
            catch (Exception exp)
            {
                LogHelper.WriteException(exp);
                context.Response.Write((JsonConvert.SerializeObject(0)));
            }
        }

        private void Transmoney(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                if(context.Request["money"] == "")
                {
                    message.IsSuccess=false;
                    message.Message ="金额不能为空";
                    
                }
                else
                {
                    int userid = new BLL.UserAccountBLL().GetModel(context.Request["fromUser"].ToString()).Id;
                    string toUser = context.Request["toUser"];
                    decimal money = Convert.ToDecimal(context.Request["money"]);
                    var result = new BLL.AccountBLL().TransMoney(userid, context.Request["toUser"], money, context.Request["remark"], context.User.Identity.Name);

                    LogHelper.WriteOperation("后台用户" + context.User.Identity.Name + "为用户转账。转出账户：" + context.Request["fromUser"] + "。转入账户：" + context.Request["toUser"], OperationType.Add, 
                        result!=0?"成功":"失败");

                    message.IsSuccess = true;
                }
                context.Response.Write(JsonConvert.SerializeObject(message));
               
            }
            catch (Exception exp)
            {
                LogHelper.WriteException(exp);
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void GetUserInfo(HttpContext context)
        {
            try
            {
                string telphone = context.Request["telphone"];
                var user = new BLL.UserAccountBLL().GetModel(telphone);
                if (user != null && user.Id != 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, data = user }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg="无效的手机号" }));
                }
            }
            catch (Exception exp)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg = exp.Message }));
                throw;
            }
            
        }

        public void ChangeStatus(HttpContext context)
        {
            try
            {
                var model = new BLL.AdminBll().GetModel(context.User.Identity.Name);
                if (model.AdminGroupsId != 1) //只有管理员可以更改
                {
                    context.Response.Write(0);
                    return;
                }

                var status = context.Request["status"];
                status = status == "是" ? "否" : "是";
                var result = _userAccountBll.ChangeVipStatus(int.Parse(context.Request["id"].ToString()), status);

                LogHelper.WriteOperation("管理员[id:" + model.AdminId+ "]" + context.User.Identity.Name + "修改了用户[id:" + context.Request["id"] + "]的vip状态，更改后状态为：" + status, OperationType.Update, "成功");
                context.Response.Write(result);
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }

        }
        private void changeBlack(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Int32.Parse(context.Request["id"]);
                var user = _userAccountBll.GetModel(id);

                if (user.IsBlack == "否")
                {
                    user.IsBlack = "是";
                }
                else
                    user.IsBlack = "否";

                new BLL.UserAccountBLL().UpdateData(user);
                message.IsSuccess = true;
                message.Message = "更改成功";
                context.Response.Write((JsonConvert.SerializeObject(message)));
            }
            catch (Exception)
            {
                message.IsSuccess = false;
                message.Message = "更改成功";
                context.Response.Write((JsonConvert.SerializeObject(message)));
            }

        }

        private void levelUser(HttpContext context)
        {

            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            int levelid = Convert.ToInt32(context.Request["levelId"]);

            string where = "1=1";
            Level l = new BLL.LevelBLL().GetModel(levelid);
            if (l != null)
                where += " and score>=" + l.ScoreLL + " and score<" + l.ScoreUL;

            var list = _userAccountBll.GetPageList(pageIndex, pageSize, " id desc ", where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
        }

        private void getGiftCard(HttpContext context)
        {
            var id = context.Request["giftId"];
            try
            {
                var model = new BLL.GiftCards().GetModel(Int32.Parse(id));
                if (model != null)
                {
                    context.Response.Write((JsonConvert.SerializeObject(model)));
                }
                else
                    context.Response.Write((JsonConvert.SerializeObject(0)));
            }
            catch (Exception)
            {
                context.Response.Write((JsonConvert.SerializeObject(0)));
            }

        }

        private void changeHideFunding(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Int32.Parse(context.Request["id"]);
                var user = _userAccountBll.GetModel(id);

                if (user.IsHideFunding == 1)
                {
                    user.IsHideFunding = 0;
                }
                else
                    user.IsHideFunding = 1;

                new BLL.UserAccountBLL().UpdateData(user);
                message.IsSuccess = true;
                message.Message = "更改成功";
                context.Response.Write((JsonConvert.SerializeObject(message)));
            }
            catch (Exception)
            {
                message.IsSuccess = false;
                message.Message = "更改成功";
                context.Response.Write((JsonConvert.SerializeObject(message)));
            }

        }

        private void rechargeMoney(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                var useraccountBll = new BLL.UserAccountBLL();
                var accoutBll = new BLL.AccountBLL();
                int id = Convert.ToInt32(context.Request["id"]);
                string rechargeNo = context.Request["rechargeNo"];
                var giftcard = new BLL.GiftCards();
                int result = 0;
                giftcard.RechargeGiftCard(id, rechargeNo, "", context.User.Identity.Name, 1, out result);
                if (result > 0)
                {
                    message.IsSuccess = true;
                    message.Message = "充值成功";
                    context.Response.Write((JsonConvert.SerializeObject(message)));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "充值失败";
                    context.Response.Write((JsonConvert.SerializeObject(message)));

                }
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                message.Message = "充值失败" + exception.Message;
                context.Response.Write((JsonConvert.SerializeObject(message)));
            }
        }

        private void cancelPermission(HttpContext context)
        {
            string tel = context.Request["tel"];
            var userModel = new BLL.UserAccountBLL().GetModel(tel);
            try
            {
                new BLL.PermissionBLL().delete(userModel.Id);
                context.Response.Write(JsonConvert.SerializeObject(new { result = 1 }));
            }
            catch
            {
                context.Response.Write(JsonConvert.SerializeObject(new { result = 0 }));
            }
        }
        private void RePassword(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            string password = context.Request["password"];
            string repassword = context.Request["repassword"];
            if (password == repassword)
            {
                try
                {
                    var user = _userAccountBll.GetModel(Int32.Parse(id));
                    _userAccountBll.RePassword(Common.EncryptAndDecrypt.Encrypt(password), id);

                    SMS.UserKefuPwd(user.Compname, password, user.Telphone);
                    //SMS.MessageSender(user.Compname + "," + password, user.Telphone, SMSTemp.UserKefuPwd);

                    message.IsSuccess = true;
                    message.Message = "";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                catch (Exception exp)
                {
                    message.IsSuccess = false;
                    message.Message = exp.Message;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }

            }
            else
            {
                message.IsSuccess = false;
                message.Message = "两次输入密码不一致";
                context.Response.Write(JsonConvert.SerializeObject(message));
            }

        }

        private void LogOrderList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string id = context.Request["id"];
            //string where = "userID=" + id;

            //var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count);
            var list = _orderBll.GetPageListByPro(0, 0, "", Int32.Parse(id), pageSize, pageIndex, out count);
            list.ForEach(a =>
            {
                a.totalMoney = a.unpaidMoney + a.orderMoney;
            });
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
        }

        private void LogAccountList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string id = context.Request["id"];
            string where = "userID=" + id;

            var list = _accountBll.GetPageList(pageIndex, pageSize, where, out count);

            List<decimal> footer = new List<decimal>();
            footer.Add(1);

            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = footer }).ToLower());
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string order = context.Request["sort"] + " " + context.Request["order"];
            string username = context.Request["username"];
            string where = "username like '%" + username + "%' and compname like '%" + context.Request["realname"] + "%' and telphone like '%" + context.Request["telphone"] + "%'";
            string times = context.Request["times"];
            string timee = context.Request["timee"];
            string isvip = context.Request["isvip"];
            if (context.Request["accountclass"] != "-1")
            {
                where += " and type=" + context.Request["accountclass"];
            }
            if (!string.IsNullOrEmpty(times) && !string.IsNullOrEmpty(timee))
            {
                where += " and registTime between '" + times + "' and '" + Convert.ToDateTime(timee).AddDays(1).AddMilliseconds(-1) + "' ";
            }

            if (order == " ")
                order = " id desc ";
            if (!string.IsNullOrEmpty(isvip))
            {
                where += " and isvip='" + isvip+"'";
            }

            var list = _userAccountBll.GetPageList(pageIndex, pageSize, order, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
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