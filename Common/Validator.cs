using System;
using System.Text.RegularExpressions;

namespace Common
{
    public static class Validator
    {
        #region 验证中文

        /// <summary>
        /// 验证中文
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isChinese(string argString)//中文
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^[\u0391-\uFFE5]+$").IsMatch(argObject);
            }
            return flag;
        }
        
        #endregion

        #region 验证邮箱

        /// <summary>
        /// 验证邮箱
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isEmail(string argString)//邮箱
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion

        #region 验证手机号

        /// <summary>
        /// 验证手机号
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isMobile(string argString)//手机号
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^1\d{10}$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion

        #region 验证小于200000000

        /// <summary>
        /// 验证小于200000000
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isInt(string argString)//小于200000000
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^1?\d{1,9}$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion

        #region 验证自然数?

        /// <summary>
        /// 验证自然数?
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isNatural(string argString)//自然数?
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex("^[A-Za-z0-9]+$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion

        #region 验证文件夹名

        /// <summary>
        /// 验证自然数?
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isLetterAndNumber(string argString)//自然数?
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex("[^a-zA-Z0-9]").IsMatch(argObject);
            }
            return !flag;
        }

        #endregion

        #region 验证用户名?

        /// <summary>
        /// 验证用户名?
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isUsername(string argString)//用户名?
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^[\u4e00-\u9fa5_a-zA-Z0-9]+$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion

        #region 验证?

        /// <summary>
        /// 验证?
        /// </summary>
        /// <param name="argString">原始字符</param>
        /// <returns></returns>
        public static bool isZip(string argString)
        {
            bool flag = false;
            string argObject = argString;
            if (!Tool.isEmpty(argObject))
            {
                flag = new Regex(@"^[0-9]\d{5}$").IsMatch(argObject);
            }
            return flag;
        }

        #endregion
    }
}
