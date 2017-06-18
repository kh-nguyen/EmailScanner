using Hangfire;
using System;
using System.Collections.Generic;
using System.Databases.Exchange;
using System.Databases.MainDatabase;
using System.Infrastructure;
using System.Linq;
using System.Models.jqGrid.Helpers;
using System.Services.EmailStorage;
using System.Utilities;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;

namespace EmailScanner.Controllers
{
    [SessionState(SessionStateBehavior.ReadOnly)]
    public class SystemController : Controller
    {
        private readonly MainDatabaseEntities mainDatabase;
        private readonly ExchangeEntities exchangeDatabase;
        private readonly HttpContextBase httpContext;

        public SystemController(
            MainDatabaseEntities mainDatabase,
            ExchangeEntities exchangeDatabase,
            HttpContextBase httpContext)
        {
            this.mainDatabase = mainDatabase;
            this.exchangeDatabase = exchangeDatabase;
            this.httpContext = httpContext;
        }

        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Contacts(jqGridParamModel grid) {
            if (!ModelState.IsValid)
                throw new ArgumentException(ModelState.GetFormattedErrorMessage());

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                var query = mainDatabase.ContactsExtendeds.AsQueryable();

                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpPost]
        public void Contacts(jqGridOperType oper, Contact model) {
            if (!ModelState.IsValid && oper != jqGridOperType.DEL) {
                throw new ArgumentException(ModelState.GetFormattedErrorMessage());
            }

            if (oper == jqGridOperType.ADD) {
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Added;
                mainDatabase.SaveChanges();
            }
            else if (oper == jqGridOperType.EDIT) {
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Modified;
                mainDatabase.SaveChanges();
            }
            else if (oper == jqGridOperType.DEL) {
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Deleted;
                mainDatabase.SaveChanges();
            }
        }

        [HttpGet]
        public ActionResult Mail(jqGridParamModel grid, int? ContactID) {
            if (!ModelState.IsValid)
                throw new ArgumentException(ModelState.GetFormattedErrorMessage());

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                var query = mainDatabase.ImportMails.AsQueryable();

                if (ContactID != null) {
                    query = query.Where(x => x.ContactID == ContactID);
                }

                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                // have to decrypt the password to show the actual value
                foreach (var item in result.rows as ImportMail[]) {
                    item.Password = EncDec.Decrypt(item.Password,
                        EmailStorageService.PASSWORD_ENCRYPTION_KEY);
                }

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpPost]
        public void Mail(jqGridOperType oper, ImportMail model) {
            if (!ModelState.IsValid && oper != jqGridOperType.DEL) {
                throw new ArgumentException(ModelState.GetFormattedErrorMessage());
            }

            if (oper == jqGridOperType.ADD) {
                model.ID = Guid.NewGuid();
                model.Password = EncDec.Encrypt(model.Password, EmailStorageService.PASSWORD_ENCRYPTION_KEY);
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Added;
                mainDatabase.SaveChanges();
            }
            else if (oper == jqGridOperType.EDIT) {
                model.Password = EncDec.Encrypt(model.Password, EmailStorageService.PASSWORD_ENCRYPTION_KEY);
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Modified;
                mainDatabase.SaveChanges();
            }
            else if (oper == jqGridOperType.DEL) {
                mainDatabase.Entry(model).State = System.Data.Entity.EntityState.Deleted;
                mainDatabase.SaveChanges();
            }
        }

        [DisableConcurrentExecution(1)]
        [AutomaticRetry(Attempts = 0, OnAttemptsExceeded = AttemptsExceededAction.Delete)]
        public static void scanEmails() {
            List<Guid> mailTasks;

            // retrieve the list of mail scanning tasks
            using (var mainDatabase = new MainDatabaseEntities()) {
                mailTasks = mainDatabase.ImportMails.Select(x => x.ID).ToList();
            }

            // scan the mail servers in parallel
            mailTasks.AsParallel().ForAll(importMailID => {
                try {
                    log4net.LogManager.GetLogger(System.Reflection
                        .MethodBase.GetCurrentMethod().DeclaringType)
                        .InfoFormat("Start scanning mailbox #{0}", importMailID);

                    using (var mainDatabase = new MainDatabaseEntities())
                    using (var exchangeDatabase = new ExchangeEntities()) {
                        IEmailStorageService emailStorageService =
                            new EmailStorageService(mainDatabase, exchangeDatabase);

                        var importMail = mainDatabase.ImportMails.Find(importMailID);
                        var numberOfItems = emailStorageService.Scan(importMail);
                    }
                }
                catch (Exception ex) {
                    log4net.LogManager.GetLogger(System.Reflection.MethodBase
                        .GetCurrentMethod().DeclaringType).Error(ex);
                }
            });
        }
    }
}