using System;
using System.Databases.Exchange;
using System.Databases.MainDatabase;
using System.Infrastructure;
using System.Linq;
using System.Models.jqGrid.Helpers;
using System.Services.EmailStorage;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;

namespace EmailScanner.Controllers
{
    [SessionState(SessionStateBehavior.ReadOnly)]
    public class EmailController : Controller
    {
        private readonly MainDatabaseEntities mainDatabase;
        private readonly ExchangeEntities exchangeDatabase;
        private readonly HttpContextBase httpContext;
        private readonly IEmailStorageService emailStorageService;

        public EmailController(
            MainDatabaseEntities mainDatabase,
            ExchangeEntities exchangeDatabase,
            HttpContextBase httpContext,
            IEmailStorageService emailStorageService) {
            this.mainDatabase = mainDatabase;
            this.exchangeDatabase = exchangeDatabase;
            this.httpContext = httpContext;
            this.emailStorageService = emailStorageService;
        }

        [HttpGet]
        public JsonNetResult Index(jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendeds;
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public JsonNetResult Promotions(jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedPromotions;
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public JsonNetResult Junks(jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedJunks;
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public JsonNetResult Main(jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var query = exchangeDatabase.MsgTrackingLogsExtendedMains;
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public JsonNetResult References(long ID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var stringReferences = exchangeDatabase.MsgTrackingLogsHeaders
                    .Where(x => x.MsgTrackingLogsID == ID && x.FieldName == "References")
                    .Select(x => x.FieldBody).FirstOrDefault();

                if (String.IsNullOrWhiteSpace(stringReferences))
                    return null;

                // break the ids string into a list
                var references = EmailStorageService.ParseMultipleIDs(stringReferences);

                // get a list of MsgTrackingLogsIDs associated with the references
                var ids = exchangeDatabase.MsgTrackingLogs
                    .Where(x => references.Contains(x.message_id))
                    .Select(x => x.ID).ToList();

                var query = exchangeDatabase.MsgTrackingLogsExtendeds.Where(x => ids.Contains(x.ID));
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public JsonNetResult Receipts(long ID, jqGridParamModel grid) {
            if (!ModelState.IsValid) {
                return null;
            }

            using (var scope = Scope.New(System.Transactions.IsolationLevel.ReadUncommitted)) {
                // turn off change tracking for high performance
                exchangeDatabase.Configuration.AutoDetectChangesEnabled = false;
                // UseDatabaseNullSemantics should be set true to improve filter performance
                exchangeDatabase.Configuration.UseDatabaseNullSemantics = true;

                var receipts = exchangeDatabase.MsgTrackingLogsReceipts
                    .Where(x => x.MsgTrackingLogsID == ID)
                    .Select(x => x.receipt_id).ToList();

                var query = exchangeDatabase.MsgTrackingLogsExtendeds.Where(x => receipts.Contains(x.ID));
                var result = jqGridResponseDefaultModel.getDefaultResponse(query, grid);

                //convert to JSON and return to client
                return this.JsonEx(result);
            }
        }

        [HttpGet]
        public ActionResult View(long ID) {
            var model = exchangeDatabase.MsgTrackingLogs.Find(ID);

            // To
            ViewBag.to_recipients = model.MsgTrackingLogsRecipientAddresses
                .Where(x => x.recipient_type == "to").ToList();

            // CC
            ViewBag.cc_recipients = model.MsgTrackingLogsRecipientAddresses
                .Where(x => x.recipient_type == "cc").ToList();

            // Headers
            ViewBag.messageInternetHeaders = model.MsgTrackingLogsHeaders.ToList();

            // compose the attachments list
            if (model != null && !String.IsNullOrEmpty(model.MsgTrackingExtendedLog.attachments)) {
                ViewBag.attachments =
                    from n in model.MsgTrackingExtendedLog.attachments.Split(
                        EmailStorageService.ATTACHMENT_SEPARATOR[0])
                    join b in model.MsgTrackingLogsAttachments
                    on n equals b.attachment_name into g
                    from b in g.DefaultIfEmpty()
                    select b;
            }

            return View(model);
        }

        [HttpGet]
        public ActionResult Attachment(long ID, bool download = true) {
            var attachment = emailStorageService.getAttachment(ID);

            if (attachment == null)
                throw new ArgumentOutOfRangeException("ID");

            //Send the attachment to client.
            var response = httpContext.Response;

            response.Clear();
            response.ContentType = (download ? "application/octet-stream" : attachment.ContentType.ToString());
            response.AddHeader("Content-Length", attachment.ContentStream.Length.ToString());
            response.AddHeader("Content-Disposition", httpContext.getContentDisposition(attachment.Name));
            response.CacheControl = "private";
            response.AddHeader("Pragma", "no-cache");
            response.Cache.SetExpires(DateTime.Now.AddDays(-100));

            attachment.ContentStream.CopyTo(Response.OutputStream);

            response.Flush();
            response.Close();

            return null;
        }
    }
}