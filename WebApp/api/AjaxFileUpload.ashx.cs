using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace WebApp.api
{
    /// <summary>
    /// AjaxFileUpload 的摘要说明
    /// </summary>
    public class AjaxFileUpload : IHttpHandler
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