using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Car
{
	public partial class CarRouteQuery : System.Web.UI.Page
	{
	    public string carno = "";
		protected void Page_Load(object sender, EventArgs e)
		{
		    if (Request.QueryString["id"] != null)
		    {
		        var model = (new CarInfoBLL()).GetModel((Request.QueryString["id"].ToString()));
		        if (model != null)
		        {
		            carno = model.CarNo;
		        }
		    }
		}
	}
}