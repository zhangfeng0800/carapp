using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// VerifyCode 的摘要说明
    /// </summary>
    public class VerifyCode : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            this.CreateCheckCodeImage(RndNum());
        }

        private string RndNum()
        {
            int number;
            char code;
            string checkCode = String.Empty;

            System.Random random = new Random();

            for (int i = 0; i < 4; i++)
            {
                number = random.Next();
                if (number % 2 == 0)
                    code = (char)('0' + (char)(number % 10));
                else
                    code = (char)('A' + (char)(number % 26));
                checkCode += code.ToString();
            }
            //HttpContext.Current.Response.Cookies.Add(new HttpCookie("VerifyCode", Common.Tool.StrUrlConvert(Common.AES.StrEncrypt(checkCode))));
            HttpContext.Current.Response.Cookies.Add(new HttpCookie("VerifyCode", checkCode));
            return checkCode;
        }
        private void CreateCheckCodeImage(string checkCode)
        {
            if (checkCode == null || checkCode.Trim() == String.Empty)
                return;
            System.Drawing.Bitmap image = new System.Drawing.Bitmap((int)Math.Ceiling((checkCode.Length * 12.5)), 22);
            Graphics g = Graphics.FromImage(image);
            try
            {
                Random random = new Random();//生成随机生成器
                g.Clear(Color.White);//清空图片背景色 
                //画图片的背景噪音线 
                for (int i = 0; i < 5; i++)//绘制次数
                {
                    int x1 = random.Next(image.Width);
                    int x2 = random.Next(image.Width);
                    int y1 = random.Next(image.Height);
                    int y2 = random.Next(image.Height);
                    g.DrawLine(new Pen(Color.RoyalBlue), x1, y1, x2, y2);
                }

                Font font = new System.Drawing.Font("Arial", 12, (System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
                System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.CornflowerBlue, Color.DodgerBlue, 1.2f, true);
                g.DrawString(checkCode, font, brush, 2, 2);

                for (int i = 0; i < 20; i++)//画图片的前景噪音点 
                {
                    int x = random.Next(image.Width);
                    int y = random.Next(image.Height);
                    image.SetPixel(x, y, Color.FromArgb(random.Next()));
                }
                //画图片的边框线 
                //g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
                System.IO.MemoryStream ms = new System.IO.MemoryStream();
                image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.ContentType = "image/Gif";
                HttpContext.Current.Response.BinaryWrite(ms.ToArray());
            }
            finally
            {
                g.Dispose();
                image.Dispose();
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