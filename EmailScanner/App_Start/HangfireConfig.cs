using EmailScanner.Controllers;
using Hangfire;
using Ninject;
using Owin;
using System;
using System.Configuration;
using System.Linq;
using System.Services.Database;

namespace EmailScanner.App_Start
{
    public static class HangfireConfig
    {
        public static void Configuration(IAppBuilder app, IKernel kernel) {
            // Connection string defined in web.config
            GlobalConfiguration.Configuration.UseSqlServerStorage("HangfireConnection");

            // register the Ninject activator
            GlobalConfiguration.Configuration.UseNinjectActivator(kernel);

            var options = new BackgroundJobServerOptions();

            var stringQueues = ConfigurationManager.AppSettings[
                "HangfireBackgroundJobServerOptionsQueues"];

            if (!String.IsNullOrWhiteSpace(stringQueues)) {
                options.Queues = stringQueues.Split(new char[] { ',' },
                    StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => x.Trim()).ToArray();
            }

            app.UseHangfireServer(options);
            app.UseHangfireDashboard();

            // run the mail scanning task every minute
            RecurringJob.AddOrUpdate(TaskCommand.LookupNewEmails.ToString(),
                () => SystemController.scanEmails(), Cron.Minutely, TimeZoneInfo.Local);
        }
    }
}