using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace EmailScanner
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start() {
            // Write to the log that the program has started. This is to ensure that the logger is configured properly.
            log4net.LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType).Info("Started");

            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_Stop() {
            log4net.LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType).Info("Stopped");
        }
    }
}
