using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace CarAppAdminWebUI
{
    public partial class Layer : System.Web.UI.Page
    {
        public UserAccount UserModel = new UserAccount();
        public string Telphone;
        public Level LevelModel = new Level();
        public Model.Admin AdminModel = new Model.Admin();
        public bool isEqual = false;
        public string caller;
        public string queryString = "";
        public string Exten;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["telphone"] != null)
            {
                queryString = Request.QueryString["telphone"];
                if (queryString.Contains(','))
                {
                    var userid = queryString.Split(',')[0];
                    caller = queryString.Split(',')[1];
                    if (userid == caller)
                    {
                        isEqual = true;
                    }
                    var userbll = new UserAccountBLL();
                    UserModel = userbll.GetModel(userid);
                    Telphone = userid;
                    var bll = new LevelBLL();
                    if (UserModel != null)
                    {
                        LevelModel = bll.GetModelByScore(UserModel.score, int.Parse(UserModel.Type.ToString()));
                    }
                }

                var cookie = Request.Cookies["exten"];
                if (cookie == null)
                {
                    Exten = "no";
                }
                else
                {
                    Exten = cookie.Value;
                }

            }
            else
            {
                Telphone = "";
            }
        }

        public string GetSex(bool? sex)
        {
            if(sex ==null)
            {
                return "先生";
            }
            return sex == true ? "先生" : "女士";
        }
    }
}