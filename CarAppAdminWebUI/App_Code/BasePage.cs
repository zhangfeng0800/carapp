﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace CarAppAdminWebUI.App_Code
{
    public class BasePage : Page
    {
        public void GoErrorPage()
        {
            Response.Redirect("/Error.aspx");
        }
    }
}