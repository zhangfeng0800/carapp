using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{
    public class Message
    {
        public const string NOTFOUND = "请求地址不存在";
        public const string BADPARAMETERS = "参数错误";
        public const String INTERNALERROR = "服务器错误";
        public const String EMPTY = "暂无数据";
        public const String SUCCESS = "请求成功";
        public const string LOGINED = "已经登录";
        public const string NOTLOGIN = "请登录";
        public const string VERIFYCODEERROR = "验证码错误";
        public const string EMPTYVERIFYCODE = "验证码为空";
        public const string LOGINFAILED = "账号或密码错误！";
        public const string ISBLACK = "黑名单用户，禁止登陆！";
    }

    public enum StatusCode
    {
        请求成功 = 1,
        请求失败 = 0,
        验证码错误 = 2,
        请输入验证码 = 3,
        用户名不存在 = 4,
        密码错误 = 5
    }

    public enum ResultCode
    {
        成功 = 0,
        网络通讯错误 = -1,
        业务操作失败 = -2,
        参数错误 = -4,
        用户名或密码错误 = -5,
        无权使用 = -6,
        无权操作 = -7,
        手机号码已经注册 = -8,
        没有更多数据 = -9
    }

}
