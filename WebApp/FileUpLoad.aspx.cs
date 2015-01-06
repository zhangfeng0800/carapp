using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class FileUpLoad : System.Web.UI.Page
    {
        protected string Message = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
              
            }
        }

        protected void btnFileUpLoad_Click(object sender, EventArgs e)
        {
            if (this.FileUpload.PostedFile != null || this.FileUpload.PostedFile.ContentLength > 0)
            {
                string ext = System.IO.Path.GetExtension(FileUpload.PostedFile.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jepg" && ext != ".bmp" && ext != ".gif" && ext != ".png")
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message",
                        "alert('图片格式非法，仅支持jpg,gif,png类型图片')", true);
                    return;
                }

                HttpPostedFile file = this.FileUpload.PostedFile;
                if (file != null)
                {
                    System.Drawing.Image image = System.Drawing.Image.FromStream(file.InputStream);

                    #region 图片上传的限制条件
                   
                 
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

                    string newFolder = "/";
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
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message",
                            "showmessage('" + Request["id"] + "','" + newFolder + newFileName + "')", true);
                        return;
                    }
                }
            }
        }

        private void Alert(string message)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "message", "alert('" + message + "')", true);
        }
    }
}