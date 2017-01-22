using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Newtonsoft.Json;
using Owin;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Web;

namespace EmailScanner.App_Start
{
    public static class LogsConfig
    {
        /// <summary>
        /// This startup configuration is executed slightly latter than Global.asax
        /// </summary>
        public static void Configuration(IAppBuilder app) {
            ThreadPool.QueueUserWorkItem(delegate {
                while (true) {
                    try {
                        var sender = new IPEndPoint(IPAddress.Any, 0);
                        var stringListenPort = ConfigurationManager.AppSettings["LogsReceiverPort"];

                        if (String.IsNullOrEmpty(stringListenPort)) {
                            log4net.LogManager.GetLogger(System.Reflection
                                .MethodBase.GetCurrentMethod().DeclaringType)
                                .Info("There is no log listening port!");
                            return;
                        }

                        using (var client = new UdpClient(int.Parse(stringListenPort))) {
                            disposeWhenShutdown(app, client);

                            while (true) {
                                var buffer = client.Receive(ref sender);

                                var stringLoggingEvent = System.Text.Encoding.Default.GetString(buffer);

                                sendSignalR(stringLoggingEvent);
                            }
                        }
                    }
                    catch (Exception ex) {
                        log4net.LogManager.GetLogger(System.Reflection
                            .MethodBase.GetCurrentMethod().DeclaringType).Error(ex);
                    }
                }
            }, null);
        }

        private static void sendSignalR(string stringLoggingEvent) {
            try {
                var hub = GlobalHost.ConnectionManager.GetHubContext<SignalrAppenderHub>();

                if (hub != null) {
                    dynamic loggingEvent = JsonConvert.DeserializeObject(stringLoggingEvent);

                    hub.Clients.All.onLoggedEvent(new {
                        loggingEvent.TimeStamp,
                        Level = loggingEvent.Level.Name,
                        Hostname = loggingEvent.Properties["log4net:HostName"],
                        loggingEvent.LoggerName,
                        loggingEvent.ThreadName,
                        loggingEvent.Identity,
                        loggingEvent.Domain,
                        loggingEvent.UserName,
                        loggingEvent.Message,
                        loggingEvent.ExceptionString
                    });
                }
            }
            catch (Exception ex) {
                log4net.LogManager.GetLogger(System.Reflection
                    .MethodBase.GetCurrentMethod().DeclaringType).Error(ex);
            }
        }

        private static void disposeWhenShutdown(IAppBuilder app, UdpClient client) {
            var context = new OwinContext(app.Properties);

            var token = context.Get<CancellationToken>("host.OnAppDisposing");

            if (token != CancellationToken.None) {
                token.Register(() => {
                    client.Close();
                });
            }
        }
    }
}