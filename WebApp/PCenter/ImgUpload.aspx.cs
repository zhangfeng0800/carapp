using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class ImgUpload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.Form["Hidden_Upload"] != "ImgUpload")
                return;
            if (!Check())
                return;
            HttpPostedFile PostedFile = HttpContext.Current.Request.Files["File_Img"];
            
            Model.UserAccount user = Session["UserInfo"] as Model.UserAccount;
            string[] NowDate = DateTime.Now.ToString("yyyy-MM-dd").Split('-');//获取时间数组
            string FileName = DateTime.Now.ToString("HHmmssffff") + user.Id;//设置文件名
            string Extension = System.IO.Path.GetExtension(PostedFile.FileName);//获取扩展名
            string PhyPath = Request.PhysicalApplicationPath + "headPic\\" + NowDate[0] + "\\" + NowDate[1] + "\\" + NowDate[2] + "\\";//设置物理路径
            if (!Directory.Exists(PhyPath))
            {
                Directory.CreateDirectory(PhyPath);
            }
            PhyPath += FileName + Extension;//完整物理路径
            PostedFile.SaveAs(PhyPath);//存储到物理路径
            string UrlPath = NowDate[0] + "/" + NowDate[1] + "/" + NowDate[2] + "/" + FileName + Extension;//完整虚拟路径
            ClientScript.RegisterStartupScript(ClientScript.GetType(), "", "<script>SetParentImgUrl(\"" + UrlPath + "\");</script>");
        }

        protected bool Check()
        {
            HttpPostedFile UpFile = HttpContext.Current.Request.Files["File_Img"];//获取文件
            String fileName = UpFile.FileName;
            String Extension = Path.GetExtension(fileName).ToLower();

            if (UpFile.FileName == null || UpFile.InputStream == null)//文件不存在
            {
                ClientScript.RegisterStartupScript(ClientScript.GetType(), "", "<script>SetParentImgUrl(\"Error1\");</script>");
                return false;
            }

            if (String.IsNullOrEmpty(Extension) || Array.IndexOf(("jpg,jpeg,gif,png").Split(','), Extension.Substring(1).ToLower()) == -1)//文件格式错误
            {
                ClientScript.RegisterStartupScript(ClientScript.GetType(), "", "<script>SetParentImgUrl(\"Error2\");</script>");
                return false;
            }

            if (UpFile.InputStream.Length > 262144)//文件大小超过限制(256KB)
            {
                ClientScript.RegisterStartupScript(ClientScript.GetType(), "", "<script>SetParentImgUrl(\"Error3\");</script>");
                return false;
            }

            return true;
        }
    }
}