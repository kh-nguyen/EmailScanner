using EmailScanner.App_Start;
using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(EmailScanner.App_Start.Startup))]
namespace EmailScanner.App_Start
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // should be executed first
            var kernel = NinjectConfig.Configuration(app);

            HangfireConfig.Configuration(app, kernel);

            SignalRConfig.Configuration(app, new HubConfiguration {
                Resolver = GlobalHost.DependencyResolver,
                EnableDetailedErrors = true
            });

            LogsConfig.Configuration(app);
        }
    }
}
