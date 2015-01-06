using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using IEZU.Log;
using Model;
using System.Web.Security;

namespace WebApp.PCenter
{
    public partial class AuthorizeUserManager : PageBase.PageBase
    {
        BLL.UserAccountBLL UAB = new UserAccountBLL();
        BLL.RestrictBLL RB = new RestrictBLL();
        protected List<Model.CarType> carTypeList = new List<CarType>();
        protected Model.UserAccount tempUser = new UserAccount();
        protected Model.Restrict tempRest = new Restrict();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Uid"] != null)
            {
                Model.UserAccount user = new BLL.UserAccountBLL().GetModel(Convert.ToInt32(Request.QueryString["Uid"]));
                if (user.Pid != userAccount.Id && new BLL.UserAccountBLL().GetMaster(user.Id).Id != userAccount.Id)
                {
                    Response.Redirect("AuthorizeUser.aspx", true);
                }
            }
            PersonCenter pCenter = (PersonCenter)this.Master;//判断是否有访问该页面的权限
            pCenter.redirectMaster = userAccount.Popedom.AuthorizeUserPage;
            if (Request.Form["Action"] != null)
                Action();
            carTypeList = new BLL.CarTypeBLL().GetList();
            //页面初始化
            if (Request.QueryString["Uid"] != null)//修改下属用户的权限
            {
                tempUser.Id = Common.Tool.GetInt(Request.QueryString["Uid"]);
                tempUser = UAB.GetModel(tempUser.Id);
                if (tempUser == null)
                    Response.Redirect("AuthorizeUser.aspx");
                tempRest = RB.GetModel(tempUser.Id);
            }
            else//添加下属用户
            {
                tempRest.Deadline = DateTime.Now;
                if (userAccount.Type == 0)
                    tempUser.Type = 1;
                else
                    tempUser.Type = 2;
            }
        }

        protected void Action() {
            if (Session["UserInfo"] == null)
            {
                Response.ContentType = "application/json";
                Response.Write("{\"Message\":\"清先登录\"}");
                Response.End();
            }

            if (userAccount.Type == 1)//如果当前角色是部门经理，要检查其权限。
            {
                Model.Restrict restThis = new BLL.RestrictBLL().GetModel(userAccount.Id);//
                if (restThis == null)//不存在限制
                {
                    Response.ContentType = "application/json";
                    Response.Write("{\"Message\":\"您的身份验证失败\"}");
                    Response.End();
                }
                if (restThis.Status == 0)
                {
                    Response.ContentType = "application/json";
                    Response.Write("{\"Message\":\"您的授权已经失效\"}");
                    Response.End();
                }
                if (restThis.Deadline < DateTime.Now)
                {
                    restThis.Status = 0;
                    RB.UpdateStatus(userAccount.Id);
                    Response.ContentType = "application/json";
                    Response.Write("{\"Message\":\"您的授权已经失效\"}");
                    Response.End();
                }
            }

            switch (Request.Form["Action"])
            {
                case "Add":
                    UserAdd();
                    break;
                case "Update":
                    UserUpdate();
                    break;
                default:
                    break;
            }
        }

        protected void UserAdd()
        {
            tempUser.Username = Request.Form["username"];
            tempUser.Compname = Request.Form["compname"];
            tempUser.Telphone = Request.Form["telphone"];
            if (UAB.Exits_Username(tempUser.Telphone) || UAB.Exits_Telphone(tempUser.Telphone))
            {
                Response.ContentType = "application/json";
                Response.Write("{\"Message\":\"该手机号已存在\"}");
                Response.End();
            }
            tempUser.Password = EncryptAndDecrypt.Encrypt(Request.Form["password"]);
            tempUser.Balance = 0.00M;
            tempUser.Email = "";
            tempUser.Type = Common.Tool.GetInt(Request.Form["type"]);
            tempUser.Pid = userAccount.Id;
            tempUser.Creater = "";
            tempUser.Tel = "";
            tempUser.isdelete = false;
            tempUser.registTime = DateTime.Now;
            tempUser.BaiduBuserid = "";
            tempUser.BaiduChannelid = "";
            tempUser.PayPassword = "";
            tempUser.DeviceType = 0;
            tempUser.CheckCode = "";
            int userId = 0;
            try
            {
                userId = UAB.AddData(tempUser);
                LogHelper.WriteOperation("添加授权用户，用户电话[" + tempUser.Telphone + "]", OperationType.Add, "添加成功", Username);
                var account = Session["UserInfo"] as UserAccount;
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                Response.ContentType = "application/json";
                Response.Write("{\"Message\":\"用户添加失败\"}");
                return;
            }

            tempRest.Deadline = Common.Tool.GetDatetime(Request.Form["deadline"]);
            tempRest.DateRest = Common.Tool.GetInt(Request.Form["dateRest"]);
            tempRest.Workday = Common.Tool.GetInt(Request.Form["workday"]);
            tempRest.TimeLL = Common.Tool.GetInt(Request.Form["timeLL"]);
            tempRest.TimeUL = Common.Tool.GetInt(Request.Form["timeUL"]);
            tempRest.CostType = Common.Tool.GetInt(Request.Form["costType"]);
            tempRest.CostToplimit = Common.Tool.GetInt(Request.Form["costToplimit"]);
            tempRest.Balance = tempRest.CostToplimit;
            tempRest.RefurbishTime = DateTime.Now;
            tempRest.CarType = Request.Form["carType"];
            tempRest.UserId = userId;
            tempRest.Status = 1;
            RB.AddRestrict(tempRest);

            Common.SMS.user_CreateNewUser(userAccount.Compname , Request.Form["password"], tempUser.Telphone);

            Response.ContentType = "application/json";
            Response.Write("{\"Message\":\"Complete\"}");
            Response.End();
        }

        protected void UserUpdate()
        {
            tempUser = UAB.GetModel(Convert.ToInt32(Request.Form["Uid"]));

            if (tempUser.Pid != userAccount.Id && new BLL.UserAccountBLL().GetMaster(tempUser.Id).Id != userAccount.Id)//当前用户必须为修改账户的上级用户或集团用户
            {
                Response.ContentType = "application/json";
                Response.Write("{\"Message\":\"操作失败！\"}");
                Response.End();
            }
            tempUser.Username = Request.Form["username"];
            tempUser.Compname = Request.Form["compname"];//真名
            tempUser.Telphone = Request.Form["telphone"];//电话
            if (Request.Form["password"] != "")
                tempUser.Password = EncryptAndDecrypt.Encrypt(Request.Form["password"]);
            tempUser.Type = Common.Tool.GetInt(Request.Form["type"]);
            tempUser.Pid = userAccount.Id;
            UAB.UpdateData(tempUser);

            tempRest = RB.GetModel(tempUser.Id);
            tempRest.Deadline = Common.Tool.GetDatetime(Request.Form["deadline"]);//失效日期
            tempRest.DateRest = Common.Tool.GetInt(Request.Form["dateRest"]);//
            tempRest.Workday = Common.Tool.GetInt(Request.Form["workday"]);//是否只能在工作日约车
            tempRest.TimeLL = Common.Tool.GetInt(Request.Form["timeLL"]);//每天约车最早时间
            tempRest.TimeUL = Common.Tool.GetInt(Request.Form["timeUL"]);//每天约车最晚时间
            tempRest.CostType = Common.Tool.GetInt(Request.Form["costType"]);//消费额度类型
            /*
             * 消费额度上限发生变化，则剩余消费金额相应跟着变化
             * 比如原本消费额度为每月1000元，当前剩余消费金额为800；
             * 1.然后消费额度调整为每月800元，则当前剩余消费金额变为600；2.然后消费额度调整为每月1200元，则当前剩余消费金额变为1000；
             */
            if (tempRest.CostToplimit != (decimal)Common.Tool.GetInt(Request.Form["costToplimit"]))
                tempRest.Balance -= (tempRest.CostToplimit - Common.Tool.GetInt(Request.Form["costToplimit"]));
            tempRest.CostToplimit = Common.Tool.GetInt(Request.Form["costToplimit"]);
            tempRest.CarType = Request.Form["carType"];
            RB.UpdateRestrict(tempRest);

            Response.ContentType = "application/json";
            Response.Write("{\"Message\":\"Complete\"}");
            Response.End();
        }
    }
}