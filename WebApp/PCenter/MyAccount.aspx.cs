using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;
using Newtonsoft.Json;

namespace WebApp.PCenter
{
    public partial class MyAccount : PageBase.PageBase
    {
        protected List<Model.Account> AccoList = new List<Model.Account>();
        protected List<Model.UserAccount> UserList = new List<UserAccount>();
        protected int MaxCount = 0;//个人流水总数
        protected int[] TypeArray = new int[3];//每种类型流水显示的数量
        protected BLL.UserAccountBLL UB = new BLL.UserAccountBLL();
        public int totalPage = 0;
        protected Level level = new Level();
        protected void Page_Load(object sender, EventArgs e)
        {
            int pageSize = 5;
            BLL.AccountBLL AB = new BLL.AccountBLL();
            string UidArrayStr = UB.GetSubIdArrayStr(userAccount.Id);//
            string UidStr = "";
            if (Request["pageIndex"] == null) //初次进入此页面
            {
                if (Request.QueryString["UserId"] == null || Convert.ToInt32(Request.QueryString["UserId"]) == userAccount.Id)
                    UidStr = UidArrayStr;
                else
                {
                    UidStr = Request.QueryString["UserId"];
                    if (UB.GetMaster(Convert.ToInt32(UidStr)).Id != userAccount.Id)
                        UidStr = UidArrayStr;
                }
                string[] DateStr = new string[2];
                if (Request.QueryString["DateLL"] != null && Request.QueryString["DateUL"] != null)
                {
                    DateTime testDateTime = new DateTime();
                    if (DateTime.TryParse(Request.QueryString["DateLL"], out testDateTime))
                        DateStr[0] = Request.QueryString["DateLL"];
                    if (DateTime.TryParse(Request.QueryString["DateUL"], out testDateTime))
                        DateStr[1] = Request.QueryString["DateUL"];
                }
                TypeArray[0] = AB.GetCountByType(99, UidArrayStr, DateStr);//全部数量
                TypeArray[1] = AB.GetCountByType(1, UidArrayStr, DateStr);//存入数量
                TypeArray[2] = AB.GetCountByType(0, UidArrayStr, DateStr);//支出数量
                UserList = UB.GetListById(UidArrayStr);//根据用户标识字符串获取用户List
                bool? TypeBit = null;
                if (Request.QueryString["Type"] != null)
                    TypeBit = Common.Tool.GetBoolNull(Request.QueryString["Type"]);
                AccoList = AB.GetList(UidStr, DateStr, TypeBit, pageSize, Common.Tool.GetInt(Request.QueryString["Previous"]), out MaxCount);

                totalPage = Convert.ToInt32(Math.Ceiling(MaxCount / (double)pageSize));
                level = new BLL.LevelBLL().GetModelByScore(userAccount.score);

            }
            else //ajax分页列表
            {
                int pageIndex = Convert.ToInt32(Request["pageIndex"]);
                if (Request["UserId"] == null || Convert.ToInt32(Request["UserId"]) == userAccount.Id)
                    UidStr = UidArrayStr;
                else
                {
                    UidStr = Request["UserId"];
                    if (UB.GetMaster(Convert.ToInt32(UidStr)).Id != userAccount.Id)
                        UidStr = UidArrayStr;
                }
                string[] DateStr = new string[2];
                if (Request["DateLL"] != null && Request["DateUL"] != null)
                {
                    DateTime testDateTime = new DateTime();
                    if (DateTime.TryParse(Request["DateLL"], out testDateTime))
                        DateStr[0] = Request["DateLL"];
                    if (DateTime.TryParse(Request["DateUL"], out testDateTime))
                        DateStr[1] = Request["DateUL"];
                }
                bool? TypeBit = null;
                if (Request["Type"] != null)
                    TypeBit = Common.Tool.GetBoolNull(Request["Type"]);
                int Previous = 0;
                if (Request["pageIndex"] != null)
                    Previous = pageSize * Convert.ToInt32(Request["pageIndex"]);
                AccoList = AB.GetList(UidStr, DateStr, TypeBit, pageSize, Common.Tool.GetInt(Previous), out MaxCount);

                Response.Write(JsonConvert.SerializeObject(new
                {
                    rowCount = MaxCount,
                    data = AccoList
                }));
                Response.End();
            }
        }
    }
}