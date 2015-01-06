using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.PCenter
{
    public partial class MyInvoiceManager : PageBase.PageBase
    {
        protected Model.Invoice invoice = new Model.Invoice();

        protected string FormMethod = "add";
        protected string updateID = "0";
        protected void Page_Load(object sender, EventArgs e)
        {
            PersonCenter pCenter = (PersonCenter)this.Master;//权限
            pCenter.redirectMaster = userAccount.Popedom.InvoicePage;//权限
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                int id = Common.Tool.GetInt(Request.QueryString["id"]);
                invoice = new BLL.InvoiceBLL().GetList(userAccount.Id).FirstOrDefault(s => s.Id == id);
                if (invoice == null)
                    Response.Redirect("MyInvoice.aspx");
                FormMethod = "update";
                updateID = id.ToString();
            }
            if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["formMethod"] == "add")
            {
                Model.Invoice invoice = new Model.Invoice();
                invoice.InvoiceHead = Request.Form["title"];
                invoice.InvoiceType = Common.Tool.GetInt(Request.Form["content"]);
                invoice.invoiceClass = Convert.ToInt32(Request.Form["Iclass"]);
                invoice.InvoiceAdress = Request.Form["address"];
                invoice.InvoiceZipCode = Request.Form["zipCode"];
                invoice.UserId = userAccount.Id;
                if (invoice.invoiceClass == 1)
                {
                    invoice.TaxpayerID = Request.Form["Text_TaxpayerID"];
                    invoice.CompAdd = Request.Form["Text_CompAdd"];
                    invoice.CompTel = Request.Form["Text_CompTel"];
                    invoice.CompBank = Request.Form["Text_CompBank"];
                    invoice.CompAccount = Request.Form["Text_CompAccount"];
                }
                else
                {
                    invoice.TaxpayerID = "";
                    invoice.CompAdd = "";
                    invoice.CompTel = "";
                    invoice.CompBank = "";
                    invoice.CompAccount = "";
                }
                new BLL.InvoiceBLL().InsertData(invoice);
                Response.Write("<script type='text/javascript'>alert('提交成功！');window.location.href='MyInvoice.aspx';</script>");
                Response.End();
              
            }
            else if (!string.IsNullOrEmpty(Request.Form["event"]) && Request.Form["formMethod"] == "update")
            {
                Model.Invoice invoice = new Model.Invoice();
                invoice.InvoiceHead = Request.Form["title"];
                invoice.InvoiceType = Convert.ToInt32(Request.Form["content"]);
                invoice.invoiceClass = Convert.ToInt32(Request.Form["Iclass"]);
                invoice.InvoiceAdress = Request.Form["address"];
                invoice.InvoiceZipCode = Request.Form["zipCode"];
                invoice.Id = Convert.ToInt32(Request.Form["updateid"]);
                invoice.UserId = userAccount.Id;
                if (invoice.invoiceClass == 1)
                {
                    invoice.TaxpayerID = Request.Form["Text_TaxpayerID"];
                    invoice.CompAdd = Request.Form["Text_CompAdd"];
                    invoice.CompTel = Request.Form["Text_CompTel"];
                    invoice.CompBank = Request.Form["Text_CompBank"];
                    invoice.CompAccount = Request.Form["Text_CompAccount"];
                }
                else
                {
                    invoice.TaxpayerID = "";
                    invoice.CompAdd = "";
                    invoice.CompTel = "";
                    invoice.CompBank = "";
                    invoice.CompAccount = "";
                }
                new BLL.InvoiceBLL().UpdateData(invoice);
                Response.Write("<script type='text/javascript'>alert('提交成功！');window.location.href='MyInvoice.aspx';</script>");
                Response.End();
              
            }
        }
    }
}