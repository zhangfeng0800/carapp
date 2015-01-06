using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Net;
using System.Text;
using CarAppAdminWebUI.App_Code;
using System.Web.Script.Serialization;

namespace CarAppAdminWebUI.Weixin
{
    public partial class ImgUpLoad : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnFileUpLoad_Click(object sender, EventArgs e)
        {
            if (this.FileUpload.PostedFile != null || this.FileUpload.PostedFile.ContentLength > 0)
            {
                string ext = System.IO.Path.GetExtension(FileUpload.PostedFile.FileName).ToLower();
                if (ext != ".jpg")
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message",
                        "alert('图片格式非法，仅支持jpg类型图片')", true);
                    return;
                }


                HttpPostedFile file = this.FileUpload.PostedFile;


                if (file != null)
                {
                    System.Drawing.Image image = System.Drawing.Image.FromStream(file.InputStream);

                    #region 图片上传的限制条件

                    if(file.ContentLength > (128*1024))
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message",
                            "alert('图片太大，支持128K以内图片')", true);
                        return;
                    }

                    string widthStr = Request.QueryString["w"];
                    if (!string.IsNullOrEmpty(widthStr))
                    {
                        int w = Convert.ToInt32(widthStr);
                        if (image.Width != w)
                        {
                            Alert(string.Format("只允许上传宽度为{0}的图片", w));
                            return;
                        }
                    }

                    string heightStr = Request.QueryString["h"];
                    if (!string.IsNullOrEmpty(heightStr))
                    {
                        int h = Convert.ToInt32(heightStr);
                        if (image.Height != h)
                        {
                            Alert(string.Format("只允许上传高度为{0}的图片", h));
                            return;
                        }
                    }

                    string max = Request.QueryString["max"];
                    if (!string.IsNullOrEmpty(max))
                    {
                        string[] maxArr = max.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        if (maxArr.Length == 2)
                        {
                            int maxw = Convert.ToInt32(maxArr[0]);
                            int maxh = Convert.ToInt32(maxArr[1]);
                            if (maxw < image.Width || maxh < image.Height)
                            {
                                Alert(string.Format("不能上传宽度大于{0}或者高度大于{1}的图片", maxw, maxh));
                                return;
                            }
                        }
                    }
                    #endregion

                    string newFolder = "../Images/";
                    string folder = Request["folder"];
                    if (!string.IsNullOrEmpty(folder))
                    {
                        newFolder += folder + "/";
                    }

                    string uploadPath =
                        HttpContext.Current.Server.MapPath(newFolder) + "\\";

                    {
                        if (!Directory.Exists(uploadPath))
                        {
                            Directory.CreateDirectory(uploadPath);
                        }
                        string newFileName = DateTime.Now.ToString("yyyyMMddhhssmm") + ext;
                        file.SaveAs(uploadPath + newFileName);

                        string result = UploadFile(WXCommon.Get_Access_token(), "image", uploadPath + newFileName, "image/jpg");
                        JavaScriptSerializer js = new JavaScriptSerializer();
                        //转换成fileUp类
                        fileUp amodel = js.Deserialize<fileUp>(result);//此处为定义的类，用以将json转成model       

                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message",
                            "showmessage('" + Request["id"] + "','" + newFolder + newFileName + "','" + Request["med"] + "','" + amodel.media_id + "')", true);
                        return;
                    }
                }
            }
        }

        private void Alert(string message)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message", "alert('" + message + "')", true);
        }

        /// <summary>
        /// 服务号：上传多媒体文件
        /// </summary>
        /// <param name="accesstoken">调用接口凭据</param>
        /// <param name="type">图片（image）、语音（voice）、视频（video）和缩略图（thumb）</param>
        /// <param name="filename">文件路径</param>
        /// <param name="contenttype">文件Content-Type类型(例如：image/jpeg、audio/mpeg)</param>
        /// <returns></returns>
        public string UploadFile(string accesstoken, string type, string filename, string contenttype)
        {
            //文件
            FileStream fileStream = new FileStream(filename, FileMode.Open, FileAccess.Read);
            BinaryReader br = new BinaryReader(fileStream);
            byte[] buffer = br.ReadBytes(Convert.ToInt32(fileStream.Length));

            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");
            //请求
            WebRequest req = WebRequest.Create(@"http://file.api.weixin.qq.com/cgi-bin/media/upload?access_token=" + accesstoken + "&type=" + type);
            req.Method = "POST";
            req.ContentType = "multipart/form-data; boundary=" + boundary;
            //组织表单数据
            StringBuilder sb = new StringBuilder();
            sb.Append("--" + boundary + "\r\n");
            sb.Append("Content-Disposition: form-data; name=\"media\"; filename=\"" + filename + "\"; filelength=\"" + fileStream.Length + "\"");
            sb.Append("\r\n");
            sb.Append("Content-Type: " + contenttype);
            sb.Append("\r\n\r\n");
            string head = sb.ToString();
            byte[] form_data = Encoding.UTF8.GetBytes(head);

            //结尾
            byte[] foot_data = Encoding.UTF8.GetBytes("\r\n--" + boundary + "--\r\n");

            //post总长度
            long length = form_data.Length + fileStream.Length + foot_data.Length;

            req.ContentLength = length;

            Stream requestStream = req.GetRequestStream();
            //这里要注意一下发送顺序，先发送form_data > buffer > foot_data
            //发送表单参数
            requestStream.Write(form_data, 0, form_data.Length);
            //发送文件内容
            requestStream.Write(buffer, 0, buffer.Length);
            //结尾
            requestStream.Write(foot_data, 0, foot_data.Length);

            requestStream.Close();
            fileStream.Close();
            fileStream.Dispose();
            br.Close();
            br.Dispose();
            //响应
            WebResponse pos = req.GetResponse();
            StreamReader sr = new StreamReader(pos.GetResponseStream(), Encoding.UTF8);
            string html = sr.ReadToEnd().Trim();
            sr.Close();
            sr.Dispose();
            if (pos != null)
            {
                pos.Close();
                pos = null;
            }
            if (req != null)
            {
                req = null;
            }
            return html;
        }
    }
}