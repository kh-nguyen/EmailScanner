using System;
using System.Databases.Exchange;
using System.Databases.MainDatabase;
using System.Infrastructure;
using System.Linq;
using System.Models.jqGrid.Helpers;
using System.Transactions;
using System.Web;
using System.Web.Mvc;

namespace EmailScanner.Controllers
{
    public class ContactController : Controller
    {
        private readonly MainDatabaseEntities mainDatabase;
        private readonly ExchangeEntities exchangeDatabase;
        private readonly HttpContextBase httpContext;

        public ContactController(
            MainDatabaseEntities mainDatabase,
            ExchangeEntities exchangeDatabase,
            HttpContextBase httpContext) {
            this.mainDatabase = mainDatabase;
            this.exchangeDatabase = exchangeDatabase;
            this.httpContext = httpContext;
        }

        [HttpGet]
        public ActionResult Detail(int ID) {
            return View(mainDatabase.ContactsExtendeds.Find(ID));
        }

        [HttpGet]
        [Route("Contact/{ContactID}/Emails")]
        public JsonNetResult Emails(long ContactID, jqGridParamModel grid) {
            if (!ModelState.IsValid)
                return null;

            using (var scope = Scope.New(IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                mainDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                mainDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = mainDatabase.ContactsEmailsExtendeds.Where(x => x.ContactID == ContactID);
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpPost]
        [Route("Contact/{ContactID}/Emails")]
        public void Emails(jqGridOperType oper, ContactsEmail model) {
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

        [HttpPost]
        [ValidateInput(false)]
        [Route("Contact/{ContactID}/Notes")]
        public void Notes(long ContactID, string notes) {
            var contact = mainDatabase.Contacts.Find(ContactID);
            contact.Notes = notes;
            mainDatabase.SaveChanges();
        }

        [HttpGet]
        [Route("Contact/{ContactID}/Emails/All")]
        public JsonNetResult All(long ContactID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedContacts
                    .Where(x => x.ContactID == ContactID);
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        [Route("Contact/{ContactID}/Emails/Promotions")]
        public JsonNetResult Promotions(long ContactID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedPromotionsContacts
                    .Where(x => x.ContactID == ContactID);
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        [Route("Contact/{ContactID}/Emails/Junks")]
        public JsonNetResult Junks(long ContactID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedJunksContacts
                    .Where(x => x.ContactID == ContactID);
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        [Route("Contact/{ContactID}/Emails/Main")]
        public JsonNetResult Main(long ContactID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedMainContacts
                    .Where(x => x.ContactID == ContactID);
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }
    }
}