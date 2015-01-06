using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// UpLoadImage 的摘要说明
    /// </summary>
    public class UpLoadImage : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            HttpPostedFile file = context.Request.Files["fileData"];
            if (file != null)
            {
                string fileName = file.FileName;
                string laseName = fileName.Substring(fileName.LastIndexOf(".", System.StringComparison.Ordinal) + 1, 
                    (fileName.Length - fileName.LastIndexOf(".", System.StringComparison.Ordinal) - 1));
                string folder = context.Request["folder"];
                string newFolder = "/Images/" + folder + "/";

                string uploadPath =
                    HttpContext.Current.Server.MapPath(newFolder) + "\\";

                {
                    if (!Directory.Exists(uploadPath))
                    {
                        Directory.CreateDirectory(uploadPath);
                    }
                    string newFileName = DateTime.Now.ToString("yyyyMMddhhssmm") + "." + laseName;
                    file.SaveAs(uploadPath + newFileName);
                    context.Response.Write(newFolder + newFileName);
                }
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