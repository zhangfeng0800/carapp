using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp
{
    public partial class Score : System.Web.UI.Page
    {
        public List<Level> data;
        protected void Page_Load(object sender, EventArgs e)
        {
            int count = 0;
            data = new LevelBLL().GetPageList(1, 50, "", out count);
        }
    }
}