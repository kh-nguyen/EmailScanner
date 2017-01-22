using Microsoft.AspNet.SignalR;
using Owin;

namespace EmailScanner.App_Start
{
    public static class SignalRConfig
    {
        public static void Configuration(IAppBuilder app, HubConfiguration config) {
            app.MapSignalR(config);
        }
    }

    public class SignalrAppenderHub : Hub { }
}