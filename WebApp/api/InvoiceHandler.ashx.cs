using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Model.InvoiceModel;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// InvoiceHandler 的摘要说明
    /// </summary>
    public class InvoiceHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "add")
            {
                AddInvoice(context);
                return;
            }
            if (context.Request["action"] == "edit")
            {
                EditInvoice(context);
            }
        }

        public void EditInvoice(HttpContext context)
        {
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请登录" }));
                return;
            }
            var userThis = context.Session["UserInfo"] as UserAccount;
            var invoice = new InvoiceBLL();
            if (context.Request["type"] == "0")
            {
                try
                {
                    var data = invoice.GetInvoicData(int.Parse(context.Request["invoiceid"]));
                    var personInvoice = new PersonalInvoice()
                    {
                        Id = int.Parse(context.Request["invoiceid"].ToString()),
                        Name = context.Request["username"].ToString(),
                        Address = context.Request["address"].ToString(),
                        CardNo = context.Request["ssn"].ToString(),
                        PostCode = context.Request["zipcode"].ToString(),
                        UserId = userThis.Id
                    };
                    context.Response.Write(invoice.UpdateInvoice(TaxType.普通发票, TaxPayerType.个人, personInvoice) > 0
                        ? JsonConvert.SerializeObject(new { resultcode = 1, msg = "操作成功" })
                        : JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
            }
            else if (context.Request["type"] == "2")
            {
                try
                {
                    var personinvoice = new PlainInvoice()
                      {
                          Id = int.Parse(context.Request["invoiceid"].ToString()),
                          Address = context.Request["address"].ToString(),
                          PostCode = context.Request["zipcode"].ToString(),
                          UserId = userThis.Id,
                          InvoiceContent = context.Request["invoicetype"],
                          Title = context.Request["invoiceHead"].ToString(),
                          TaxSeriesNo = context.Request["TaxpayerID"]
                      };
                    context.Response.Write(invoice.UpdateInvoice(TaxType.普通发票, TaxPayerType.单位, personinvoice) > 0
                    ? JsonConvert.SerializeObject(new { resultcode = 1, msg = "操作成功" })
                    : JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
            }
            else
            {
                try
                {
                    var personinvoice = new ValueAddedInvoice()
                      {
                          InvoiceClass = context.Request["invoiceClass"].ToString(),
                          Address = context.Request["address"].ToString(),
                          PostCode = context.Request["zipcode"].ToString(),
                          UserId = userThis.Id,
                          InvoiceContent = context.Request["invoicetype"],
                          Title = context.Request["invoiceHead"].ToString(),
                          TaxSeriesNo = context.Request["TaxpayerID"],
                          AccountBank = context.Request["CompBank"],
                          CompanyAccount = context.Request["CompAccount"],
                          CompanyAddress = context.Request["compadd"],
                          Telphone = context.Request["comptel"],
                          AgentCard = context.Request["agentid"],
                          BankAccountPermission = context.Request["bankpermission"],
                          BusinessLicence = context.Request["licence"],
                          CommonTaxPayLicence = context.Request["commontaxpayer"],
                          OrgCodeLicence = context.Request["orglicense"],
                          LegalPersonCard = context.Request["lawerid"],
                          TaxPayLicence = context.Request["taxlicense"],
                          InstrduceEnvelope = context.Request["introductmsg"],
                          InvoiceResource = context.Request["resource"],
                          Id = int.Parse(context.Request["invoiceid"].ToString())
                      };
                    context.Response.Write(invoice.UpdateInvoice(TaxType.增值税发票, TaxPayerType.单位, personinvoice) > 0
                      ? JsonConvert.SerializeObject(new { resultcode = 1, msg = "操作成功" })
                      : JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
                }
            }
        }
        public void AddInvoice(HttpContext context)
        {
            if (context.Session["UserInfo"] == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请登录" }));
                return;
            }
            try
            {
                var userThis = context.Session["UserInfo"] as UserAccount;
                InvoiceBase personinvoice;
                var invoice = new InvoiceBLL();
                var invoiceid = 0;
                if (context.Request["invoice"] == "0")
                {
                    personinvoice = new PersonalInvoice()
                    {
                        Name = context.Request["username"].ToString(),
                        Address = context.Request["address"].ToString(),
                        CardNo = context.Request["ssn"].ToString(),
                        PostCode = context.Request["zipcode"].ToString(),
                        UserId = userThis.Id
                    };
                    invoiceid = invoice.InsertInvoice(TaxType.普通发票, TaxPayerType.个人, personinvoice);
                }
                else if (context.Request["invoice"] == "1")
                {
                    personinvoice = new PlainInvoice()
                    {
                        InvoiceClass = context.Request["invoiceClass"].ToString(),
                        Address = context.Request["address"].ToString(),
                        PostCode = context.Request["zipcode"].ToString(),
                        UserId = userThis.Id,
                        InvoiceContent = context.Request["invoicetype"],
                        Title = context.Request["invoiceHead"].ToString(),
                        TaxSeriesNo = context.Request["TaxpayerID"]
                    };
                    invoiceid = invoice.InsertInvoice(TaxType.普通发票, TaxPayerType.单位, personinvoice);
                }
                else if (context.Request["invoice"] == "2")
                {
                    personinvoice = new ValueAddedInvoice()
                    {
                        InvoiceClass = context.Request["invoiceClass"].ToString(),
                        Address = context.Request["address"].ToString(),
                        PostCode = context.Request["zipcode"].ToString(),
                        UserId = userThis.Id,
                        InvoiceContent = context.Request["invoicetype"],
                        Title = context.Request["invoiceHead"].ToString(),
                        TaxSeriesNo = context.Request["TaxpayerID"],
                        AccountBank = context.Request["CompBank"],
                        CompanyAccount = context.Request["CompAccount"],
                        CompanyAddress = context.Request["compadd"],
                        Telphone = context.Request["comptel"],
                        AgentCard = context.Request["agentid"],
                        BankAccountPermission = context.Request["bankpermission"],
                        BusinessLicence = context.Request["licence"],
                        CommonTaxPayLicence = context.Request["commontaxpayer"],
                        OrgCodeLicence = context.Request["orglicense"],
                        LegalPersonCard = context.Request["lawerid"],
                        TaxPayLicence = context.Request["taxlicense"],
                        InstrduceEnvelope = context.Request["introductmsg"],
                        InvoiceResource = context.Request["resource"]
                    };
                    invoiceid = invoice.InsertInvoice(TaxType.增值税发票, TaxPayerType.单位, personinvoice);
                }
                else
                {
                    personinvoice = new PersonalInvoice();
                }
                context.Response.Write(invoiceid > 0
                    ? JsonConvert.SerializeObject(new { resultcode = 1, msg = "添加成功" })
                    : JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = -1, msg = "操作失败" }));
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