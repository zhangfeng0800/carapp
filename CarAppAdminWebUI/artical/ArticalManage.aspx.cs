using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;

namespace CarAppAdminWebUI.artical
{
    public partial class ArticalManage : System.Web.UI.Page
    {
        protected string contentSate = "";
        protected string hasImage = "0";
        protected string action = "AddContent";
        protected Model.ArticalContent content = new Model.ArticalContent();
        protected List<Model.Artical> articalTypes = new List<Model.Artical>();
        protected Model.Artical checkGetArtical = new Model.Artical();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["method"] == "add")
            {
                int typeID;
                typeID = Convert.ToInt32(Request.QueryString["typeID"]);
                if (typeID == 0)
                {
                    typeID = BLL.ArticalBLL.GetFirstArticaltypeID();
                    setArticalTypesByTypeID(typeID);
                    checkGetArtical = (from c in articalTypes where c.ID == typeID select c).FirstOrDefault();
                    if (checkGetArtical.hasImage == 1)
                    {
                        hasImage = "1";
                    }
                }
                else
                {
                    setArticalTypesByTypeID(typeID);
                    checkGetArtical = (from c in articalTypes where c.ID == typeID select c).FirstOrDefault();
                    if (checkGetArtical.hasImage == 1)
                    {
                        hasImage = "1";
                    }
                }
            }
            else if (Request.QueryString["method"] == "update")
            {
                int contentID = Convert.ToInt32(Request.QueryString["contentID"]);
                setArticalTypes(contentID);
                int typeID = BLL.ArticalContent.getArticalTypeID(contentID);

                checkGetArtical = (from c in articalTypes where c.ID == typeID select c).FirstOrDefault();
                if (checkGetArtical == null)
                {
                    checkGetArtical=new Artical();
                }
                content = BLL.ArticalContent.GetArticalContentByID(contentID);
                action = "upDateContent";
                if (checkGetArtical.hasImage == 1)
                {
                    hasImage = "1";
                }
            }
        }
        protected void setArticalTypes(int? contentID)
        {
            articalTypes = BLL.ArticalBLL.GetArticalList();
            if (contentID != 0 && contentID != null)
            {
                int contentid = Convert.ToInt32(contentID);
                int typeID = BLL.ArticalContent.getArticalTypeID(contentid);
                List<Model.Artical> articaltypees = new List<Model.Artical>();
                Model.Artical artical = (from s in articalTypes where s.ID == typeID select s).FirstOrDefault();
                articaltypees.Add(artical);
                articalTypes.Remove(artical);
                foreach (var item in articalTypes)
                {
                    articaltypees.Add(item);
                }
                articalTypes = articaltypees;
            }

        }
        protected void setArticalTypesByTypeID(int typeID)
        {
            articalTypes = BLL.ArticalBLL.GetArticalList();
            List<Model.Artical> articaltypees = new List<Model.Artical>();
            Model.Artical artical = (from s in articalTypes where s.ID == typeID select s).FirstOrDefault();
            articaltypees.Add(artical);
            articalTypes.Remove(artical);
            foreach (var item in articalTypes)
            {
                articaltypees.Add(item);
            }
            articalTypes = articaltypees;
        }
    }
}