using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Text.RegularExpressions;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

namespace Common
{
    public static class Tool
    {
        #region 浮点取整

        /// <summary>
        /// 浮点数取证
        /// </summary>
        /// <param name="f">浮点数</param>
        /// <param name="round">四舍五入</param>
        /// <returns></returns>
        public static int FloatRounding(decimal f, bool round)
        {
            string strF = f.ToString();
            if (strF.IndexOf('.') == -1)
                return Convert.ToInt32(strF);
            bool bigger4 = Convert.ToInt32(strF[strF.IndexOf('.') + 1].ToString()) > 4;
            strF = strF.Remove(strF.IndexOf('.'));
            if (round && bigger4)
                return (Convert.ToInt32(strF) + 1);
            else
                return Convert.ToInt32(strF);
        }

        #endregion

        #region 截取字符串

        public static string StrCut(string Text, int TextCount, bool HtmlText)
        {
            if (Text == null)//空字符串
                return "";
            if (HtmlText == true)//HTML字符串
                Text = StrHtmlFilter(Text);
            if (TextCount < 1)
                TextCount = 1;
            return Text.Length > TextCount ? Text.Substring(0, TextCount - 1) + "…" : Text;
        }

        #endregion

        #region 去除HTLM标签

        /// <summary>
        /// 去除HTLM标签
        /// </summary>
        /// <param name="HtmlStr">原始字符串</param>
        /// <returns></returns>
        public static string StrHtmlFilter(string HtmlStr)
        {
            if (HtmlStr == null)
            {
                return "";
            }
            //Regex regex = new Regex("<.+?>", RegexOptions.IgnoreCase);
            HtmlStr = StrReplace(HtmlStr, "<.+?>", ""); //regex.Replace(HtmlStr, "");
            HtmlStr = HtmlStr.Replace("\r", "");
            HtmlStr = HtmlStr.Replace("\n", "");
            HtmlStr = HtmlStr.Replace("\t", "");
            return HtmlStr;
        }

        #endregion

        #region 去除非数字字符

        /// <summary>
        /// 去除HTLM标签
        /// </summary>
        /// <param name="HtmlStr">原始字符串</param>
        /// <returns></returns>
        public static int StrNonCountFilter(string StrCount)
        {
            if (StrCount == null)
            {
                return 0;
            }
            Regex regex = new Regex("[^\\d]", RegexOptions.IgnoreCase);
            StrCount = regex.Replace(StrCount, "");
            if (StrCount == "" || !Common.Validator.isInt(StrCount))
            {
                StrCount = "0";
            }
            return Convert.ToInt32(StrCount);
        }

        #endregion

        #region URL编码转换

        /// <summary>
        /// 转换为URL编码
        /// </summary>
        /// <param name="Str">原始字符串</param>
        /// <returns></returns>
        public static string StrUrlConvert(string Str)
        {
            return HttpUtility.UrlEncode(Str);
        }

        /// <summary>
        /// 反转URL编码
        /// </summary>
        /// <param name="Str">原始字符串</param>
        /// <returns></returns>
        public static string StrUrlReverse(string Str)
        {
            return HttpUtility.UrlDecode(Str);
        }

        #endregion

        #region 计算百分比

        /// <summary>
        /// 计算百分比,上限为100%
        /// </summary>
        /// <param name="Numerator">分子</param>
        /// <param name="Denominator">分母</param>
        /// <returns></returns>
        public static string Percentage(int Numerator, int Denominator)
        {
            string Result = "";
            float Quotient = float.Parse(Numerator.ToString()) / float.Parse(Denominator.ToString());
            try
            {
                Result = Quotient < 1 ? (Quotient).ToString("#0.00").Split('.')[1] + "%" : "100%";
            }
            catch
            {
            }
            return Result;
        }

        #endregion

        #region 转换文章里的换行、回车、空格


        /// <summary>
        /// 转换文章里的换行、回车、空格
        /// </summary>
        /// <param name="OriginalText">原始字符串</param>
        /// <param name="HtmlText">是否为HTML字符串</param>
        /// <returns></returns>
        public static string ConvertEnterSpace(string OriginalText, bool HtmlText)
        {
            if (HtmlText)
            {
                string NewText = GetString(OriginalText).Replace("\r\n", "<br/>");
                NewText = NewText.Replace("  ", "　");
                NewText = NewText.Replace(" ", "&nbsp");
                return NewText;
            }
            else
            {
                string NewText = GetString(OriginalText).Replace("<br/>", "\r\n");
                NewText = NewText.Replace("&nbsp", " ");
                return NewText;
            }
        }

        #endregion

        #region 初始化空字符串

        /// <summary>
        /// 初始化空字符串
        /// </summary>
        /// <param name="argString"></param>
        /// <returns>原始字符串</returns>

        public static string GetString(Object argString)
        {
            if (argString == DBNull.Value)
            {
                argString = "";
            }
            if (argString == null)
            {
                argString = "";
            }
            return argString.ToString();
        }

        #endregion

        #region 初始化整型数

        public static int GetInt(Object Obj)
        {
            int SourceInt = 0;
            try
            {
                SourceInt = Convert.ToInt32(Obj);
            }
            catch
            {
            }
            return SourceInt;
        }

        public static int? GetIntNull(Object Obj)
        {
            int? SourceInt = null;
            try
            {
                SourceInt = Convert.ToInt32(Obj);
            }
            catch
            {
            }
            return SourceInt;
        }

        #endregion

        #region 初始化布尔值

        public static bool GetBool(Object Obj)
        {
            bool SourceBool = false;
            try
            {
                SourceBool = Convert.ToBoolean(Obj);
            }
            catch
            {
            }
            return SourceBool;
        }

        public static bool? GetBoolNull(Object Obj)
        {
            if (Obj == null || Obj.ToString() == "")
                return null;
            bool? SourceBoolNull = null;
            try
            {
                SourceBoolNull = Convert.ToBoolean(Obj);
            }
            catch
            {
            }
            return SourceBoolNull;
        }

        #endregion

        #region 初始化时间变量

        public static DateTime GetDatetime(Object Obj)
        {
            DateTime SourceDatetime = new DateTime();
            try
            {
                SourceDatetime = Convert.ToDateTime(Obj);
            }
            catch
            {
            }
            return SourceDatetime;
        }

        public static DateTime? GetDatetimeNull(Object Obj)
        {
            if (Obj.ToString() == "" || Obj == null)
                return null;
            DateTime SourceDatetime = new DateTime();
            try
            {
                SourceDatetime = Convert.ToDateTime(Obj);
            }
            catch
            {
            }
            return SourceDatetime;
        }

        #endregion

        #region 判断是否为空字符串

        /// <summary>
        /// 判断是否为空字符串
        /// </summary>
        /// <param name="argObject">原始字符串</param>
        /// <returns></returns>

        public static bool isEmpty(object argObject)
        {
            bool flag = false;
            string argString = (string)argObject;
            if (GetString(argString) == "")
            {
                flag = true;
            }
            return flag;
        }

        #endregion

        #region 正则Split字符划分

        public static string[] StrSplit(string Strsource, string StrRegex)
        {
            return Regex.Split(Strsource, StrRegex, RegexOptions.IgnoreCase);
        }

        #endregion

        #region 正则获取符合的字符串数组

        public static string[] StrMatch(string Strsource, string StrRegex)
        {
            Regex RegexPattern = new Regex(StrRegex, RegexOptions.IgnoreCase);
            MatchCollection MC = RegexPattern.Matches(Strsource);
            string[] MatchArray = new string[MC.Count];
            for (int i = 0, max = MatchArray.Length; i < max; i++)
            {
                MatchArray[i] = MC[i].Value;
            }
            return MatchArray;
        }

        #endregion

        #region 正则字符替换

        public static string StrReplace(string Strsource, string StrRegex, string StrReplace)
        {
            return Regex.Replace(Strsource, StrRegex, StrReplace, RegexOptions.IgnoreCase);
        }

        #endregion

        #region 参数替换

        public static string QSR(string Sort, string NewValue)//QueryStringReplace
        {
            string QueryStr = HttpContext.Current.Request.QueryString.ToString();
            string NewQueryStr = "";
            if (QueryStr.IndexOf(Sort + "=") != -1)
            {
                int StrStart = QueryStr.IndexOf(Sort + "=") + Sort.Length + 1;
                int SortLength = QueryStr.Substring(StrStart).IndexOf('&') == -1 ? QueryStr.Substring(StrStart).Length : QueryStr.Substring(StrStart).IndexOf('&');
                NewQueryStr = QueryStr.Substring(0, StrStart) + NewValue + QueryStr.Substring(StrStart + SortLength);
            }
            else
            {
                if (QueryStr.IndexOf('?') != -1)
                    NewQueryStr = QueryStr + "&" + Sort + "=" + NewValue;
                else
                    NewQueryStr = QueryStr + "?" + Sort + "=" + NewValue;
            }
            return NewQueryStr;
        }

        #endregion

        #region 判断一个数组里是否包含着某个字符串

        /// <summary>
        /// 判断一个数组里是否包含着某个字符串
        /// </summary>
        /// <param name="StrArray"></param>
        /// <param name="Str"></param>
        /// <returns></returns>

        public static bool ContainsInArray(string[] StrArray, string Str)
        {
            bool Contain = false;
            for (int i = 0; i < StrArray.Length; i++)
            {
                if (StrArray[i] == Str)
                {
                    Contain = true;
                    break;
                }
            }
            return Contain;
        }

        #endregion

        #region 图片标签替换

        public static string ImgTagZoom(string Strsource)
        {
            if (Strsource == null)
                return "";
            Regex regex = new Regex("<(img|IMG).*?/>", RegexOptions.IgnoreCase);//img或input
            MatchCollection HtmlStr = regex.Matches(Strsource);
            for (int i = 0; i < HtmlStr.Count; i++)
            {
                Strsource = Strsource.Replace(HtmlStr[i].Value, HtmlStr[i].Value.Replace("/>", " onmousewheel=\"return bbimg(this)\"/>"));
            }
            return Strsource;
        }

        #endregion

        #region 字符数组转换为数字数组

        public static int[] StrArrayToIntArray(string[] StrArray)
        {
            int[] intArray = null;

            try
            {
                intArray = new int[StrArray.Length];
                for (int i = 0, max = StrArray.Length; i < max; i++)
                {
                    intArray[i] = Convert.ToInt32(StrArray[i]);
                }
            }
            catch
            {
                return intArray;
            }
            return intArray;
        }

        #endregion

        #region 删除数组中的某项

        public static int[] RemoveItemInArray(int[] ObjArray, int ItemNo)
        {
            int[] ReturnArray = null;
            if (ObjArray.Length > 0)
                ReturnArray = new int[ObjArray.Length - 1];

            for (int i = 0; i < ItemNo; i++)
            {
                ReturnArray[i] = ObjArray[i];
            }

            for (int max = ObjArray.Length - 1; ItemNo < max; ItemNo++)
            {
                ReturnArray[ItemNo] = ObjArray[ItemNo + 1];
            }

            return ReturnArray;
        }

        public static string[] RemoveItemInArray(string[] ObjArray, int ItemNo)
        {
            string[] ReturnArray = null;
            if (ObjArray.Length > 0)
                ReturnArray = new string[ObjArray.Length - 1];

            for (int i = 0; i < ItemNo; i++)
            {
                ReturnArray[i] = ObjArray[i];
            }

            for (int max = ObjArray.Length - 1; ItemNo < max; ItemNo++)
            {
                ReturnArray[ItemNo] = ObjArray[ItemNo + 1];
            }

            return ReturnArray;
        }

        #endregion

        #region 合并数组为字符串

        public static string Join(object[] ObjArray, char SplitStr)
        {
            string Str = "";
            for (int i = 0, max = ObjArray.Length; i < max; i++)
            {
                Str += SplitStr + ObjArray[i].ToString();
            }
            Str = Str.Length > 0 ? Str.Substring(1) : Str;
            return Str;
        }

        #endregion

        #region 序列化

        ///<summary> 
        /// 序列化 
        /// </summary> 
        /// <param name="data">要序列化的对象</param> 
        /// <returns>返回存放序列化后的数据缓冲区</returns> 
        public static byte[] Serialize(object data)
        {
            BinaryFormatter formatter = new BinaryFormatter();
            MemoryStream rems = new MemoryStream();
            formatter.Serialize(rems, data);
            return rems.GetBuffer();
        }

        /// <summary> 
        /// 反序列化 
        /// </summary> 
        /// <param name="data">数据缓冲区</param> 
        /// <returns>对象</returns> 
        public static object Deserialize(byte[] data)
        {
            BinaryFormatter formatter = new BinaryFormatter();
            MemoryStream rems = new MemoryStream(data);
            data = null;
            return formatter.Deserialize(rems);
        }

        #endregion

        #region 序列化文件

        ///<summary> 
        /// 序列化 
        /// </summary> 
        /// <param name="data">要序列化的对象</param> 
        /// <returns>返回存放序列化后的数据缓冲区</returns> 
        public static void FileSerialize(object data, string path)
        {
            FileStream fs = new FileStream(path, FileMode.Create);
            BinaryFormatter formatter = new BinaryFormatter();
            formatter.Serialize(fs, Common.AES.ObjEncrypt(data));
            fs.Close();
        }

        /// <summary> 
        /// 反序列化 
        /// </summary> 
        /// <param name="data">数据缓冲区</param> 
        /// <returns>对象</returns> 
        public static object FileDeserialize(string path)
        {
            FileStream fs = new FileStream(path, FileMode.Open);
            BinaryFormatter formatter = new BinaryFormatter();
            object obj = Common.AES.ObjDecrypt(formatter.Deserialize(fs).ToString());
            fs.Close();
            return obj;
        }

        #endregion

        #region 获取年龄

        /// <summary>
        /// 获取年龄
        /// </summary>
        /// <param name="birthday">生日</param>
        /// <returns></returns>
        public static int GetAge(DateTime birthday)
        {
            TimeSpan ts = DateTime.Now.Subtract(birthday);
            return (ts.Days / 365);
        }

        #endregion

        #region 过滤sql语句注入
        public static string SqlFilter(string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return "";
            }
            str = str.Replace("\'", "‘");
            str = str.Replace("\"", "“");
            str = str.Replace(",", "，");
            str = str.Replace(";", "；");
            str = str.Replace("--", "——");
            str = str.Replace("%", "‘");
            return str;
        }
        #endregion

        #region 检测是否存在sql注入的危险
        public static bool IsSqlinject(string str)
        {
            string[] dangerSql = { "'", "\"", ",", ";", "--" };
            return dangerSql.Any(str.Contains);
        }
        #endregion

        #region 获取随机验证码

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Length">长度</param>
        /// <param name="Type">类型-0:数字,1:字母,3:字母加数字</param>
        /// <returns></returns>
        public static string GetRandomCode(int Length, int Type)
        {
            int number;
            char code;
            string checkCode = String.Empty;
            System.Random random = new Random();
            for (int i = 0; i < Length; i++)
            {
                number = random.Next();
                switch (Type)
                {
                    case 0:
                        code = (char)('0' + (char)(number % 10));
                        break;
                    case 1:
                        code = (char)('A' + (char)(number % 26));
                        break;
                    default:
                        if (number % 2 == 0)
                        {
                            code = (char)('0' + (char)(number % 10));
                        }
                        else
                        {
                            code = (char)('A' + (char)(number % 26));
                        }
                        break;
                }
                checkCode += code.ToString();
            }
            return checkCode;
        }

        #endregion

        /// <summary>
        /// 提取汉字首字母
        /// </summary>
        /// <param name="strText">需要转换的字</param>
        /// <returns>转换结果</returns>
        public static string GetChineseSpell(string strText)
        {
            int len = strText.Length;
            string myStr = "";
            for (int i = 0; i < len; i++)
            {
                myStr += getSpell(strText.Substring(i, 1));
            }
            return myStr;
        }
        /// <summary>
        /// 把提取的字母变成小写
        /// </summary>
        /// <param name="strText">需要转换的字符串</param>
        /// <returns>转换结果</returns>
        public static string GetLowerChineseSpell(string strText)
        {
            return GetChineseSpell(strText).ToLower();
        }
        /// <summary>
        /// 把提取的字母变成大写
        /// </summary>
        /// <param name="myChar">需要转换的字符串</param>
        /// <returns>转换结果</returns>
        public static string GetUpperChineseSpell(string strText)
        {
            return GetChineseSpell(strText).ToUpper();
        }
        /// <summary>
        /// 获取单个汉字的首拼音
        /// </summary>
        /// <param name="myChar">需要转换的字符</param>
        /// <returns>转换结果</returns>
        public static string getSpell(string myChar)
        {
            byte[] arrCN = System.Text.Encoding.Default.GetBytes(myChar);
            if (arrCN.Length > 1)
            {
                int area = (short)arrCN[0];
                int pos = (short)arrCN[1];
                int code = (area << 8) + pos;
                int[] areacode = { 45217, 45253, 45761, 46318, 46826, 47010, 47297, 47614, 48119, 48119, 49062, 49324, 49896, 50371, 50614, 50622, 50906, 51387, 51446, 52218, 52698, 52698, 52698, 52980, 53689, 54481 };
                for (int i = 0; i < 26; i++)
                {
                    int max = 55290;
                    if (i != 25) max = areacode[i + 1];
                    if (areacode[i] <= code && code < max)
                    {
                        return System.Text.Encoding.Default.GetString(new byte[] { (byte)(65 + i) });
                    }
                }
                return "_";
            }
            else return myChar;
        }

        public static decimal ParseFloatToDecimal(float num,int digits=2)
        {
            return (decimal) Math.Round(num, 2);
        }

        //替换某些非法字符
        public static string FormatString(string content)
        {
            return content.Replace("'", "&#39;").Replace("\"", "&#34;").Replace("<", "&#60;").Replace(">", "&#62;");
        }

        public static bool IsDate(string content)
        {
            DateTime dt;
            return DateTime.TryParse(content, out dt);
        }
 
    }
}
