using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using BLL;

namespace CarAppAdminWebUI
{
    /// <summary>
    /// UserService 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。
    // [System.Web.Script.Services.ScriptService]
    public class UserService : System.Web.Services.WebService
    {

        /// <summary>
        /// 呼叫中心验证电话是否注册
        /// </summary>
        /// <param name="telphone"></param>
        /// <returns></returns>
        [WebMethod(Description = "呼叫中心验证电话是否注册")]
        public bool CheckMobileExist(string telphone)
        {
            if (string.IsNullOrEmpty(telphone))
            {
                return false;
            }
            var userbll = new UserAccountBLL();
            return userbll.Exits_Telphone(telphone);

        }

        [WebMethod(Description = "呼叫中心电话号码密码登陆")]
        public string LoginByTelphone(string telphone, string password)
        {
            if (string.IsNullOrEmpty(telphone))
            {
                return "请输入电话号码";
            }
            if (string.IsNullOrEmpty(password))
            {
                return "请输入密码";
            }
            var userbll = new UserAccountBLL();
            if (!userbll.Exits_Telphone(telphone))
            {
                return "用户不存在";
            }
            var account = userbll.CheckPayPassword(telphone, Common.EncryptAndDecrypt.Encrypt(password));
            if (!account)
            {
                return "密码错误";
            }
            return "成功";
        }

    }
}
