using System;
using System.Configuration;
using System.Web;
using System.Web.Optimization;

namespace EmailScanner
{
    public class BundleConfig
    {
        /// <summary>
        /// Use the i18n language code
        /// </summary>
        public static readonly string[] LANGUAGES = new string[] { "en" };

        public static readonly string[][] JQUERY_UI_THEMES = new string[][] {
            new string [] { "black-tie", "theme_90_black_tie.png", "Black Tie" },
            new string [] { "blitzer", "theme_90_blitzer.png", "Blitzer" },
            new string [] { "cupertino", "theme_90_cupertino.png", "Cupertino" },
            new string [] { "dark-hive", "theme_90_dark_hive.png", "Dark Hive" },
            new string [] { "dot-luv", "theme_90_dot_luv.png", "Dot Luv" },
            new string [] { "eggplant", "theme_90_eggplant.png", "Eggplant" },
            new string [] { "excite-bike", "theme_90_excite_bike.png", "Excite Bike" },
            new string [] { "flick", "theme_90_flick.png", "Flick" },
            new string [] { "hot-sneaks", "theme_90_hot_sneaks.png", "Hot Sneaks" },
            new string [] { "humanity", "theme_90_humanity.png", "Humanity" },
            new string [] { "le-frog", "theme_90_le_frog.png", "Le Frog" },
            new string [] { "mint-choc", "theme_90_mint_choco.png", "Mint Choc" },
            new string [] { "overcast", "theme_90_overcast.png", "Overcast" },
            new string [] { "pepper-grinder", "theme_90_pepper_grinder.png", "Pepper Grinder" },
            new string [] { "redmond", "theme_90_windoze.png", "Redmond" },
            new string [] { "smoothness", "theme_90_smoothness.png", "Smoothness" },
            new string [] { "south-street", "theme_90_south_street.png", "South Street" },
            new string [] { "start", "theme_90_start_menu.png", "Start" },
            new string [] { "sunny", "theme_90_sunny.png", "Sunny" },
            new string [] { "swanky-purse", "theme_90_swanky_purse.png", "Swanky Purse" },
            new string [] { "trontastic", "theme_90_trontastic.png", "Trontastic" },
            new string [] { "ui-darkness", "theme_90_ui_dark.png", "UI Darkness" },
            new string [] { "ui-lightness", "theme_90_ui_light.png", "UI Lightness" },
            new string [] { "vader", "theme_90_black_matte.png", "Vader" }
        };

        const string JQUERY_VERSION = "2.2.4";
        const string JQUERY_UI_VERSION = "1.12.1";
        const string JQGRID_VERSION = "4.13.4";
        const string BOOTSTRAP_VERSION = "3.3.7";
        const string TIMEAGO_VERSION = "1.5.3";
        const string TIMEPICKER_VERSION = "1.6.1";
        const string ANGULARJS_VERSION = "1.5.9";
        const string FONT_AWESOME_VERSION = "4.7.0";
        const string CKEDITOR_VERSION = "4.5.11";

        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles) {
            bundles.UseCdn = bool.Parse(ConfigurationManager.AppSettings["UseCdn"]);
            BundleTable.EnableOptimizations = bundles.UseCdn;

            #region jQuery
            bundles.Add(new ScriptBundle("~/bundles/jquery",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jquery/{0}/jquery.min.js", JQUERY_VERSION))
                .Include("~/Scripts/jquery-{version}.js"));
            #endregion

            #region jQuery UI
            bundles.Add(new ScriptBundle("~/bundles/jqueryui",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jqueryui/{0}/jquery-ui.min.js", JQUERY_UI_VERSION))
                .Include("~/Scripts/jquery-ui-{version}.js"));

            // the default jQuery UI theme is base
            bundles.Add(new StyleBundle("~/Content/themes/base/css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jqueryui/{0}/themes/cupertino/jquery-ui.min.css", JQUERY_UI_VERSION))
                .Include("~/Content/themes/base/all.css"));

            foreach (var item in JQUERY_UI_THEMES) {
                bundles.Add(new StyleBundle("~/Content/themes/" + item[0] + "/css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jqueryui/{0}/themes/{1}/jquery-ui.min.css", JQUERY_UI_VERSION, item[0]))
                // when not use CDN then all themes will be 'base'
                .Include("~/Content/themes/" + (bundles.UseCdn ? "base/all.css" : (item[0] + "/jquery-ui.css"))));
            }

            #endregion

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                "~/Scripts/bootstrap.js",
                "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/Content/jqGrid.css",
                "~/Content/site.css"));

            bundles.Add(new ScriptBundle("~/bundles/system/js")
                .Include("~/Scripts/System.js"));

            bundles.Add(new ScriptBundle("~/bundles/angular",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/angular.js/{0}/angular.min.js", ANGULARJS_VERSION))
                .Include("~/Scripts/angular.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/signalR/js",
                "//cdnjs.cloudflare.com/ajax/libs/signalr.js/2.2.1/jquery.signalR.min.js")
                .Include("~/Scripts/jquery.signalR-{version}.js"));

            bundles.Add(new StyleBundle("~/bundles/font-awesome",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/font-awesome/{0}/css/font-awesome.min.css", FONT_AWESOME_VERSION))
                .Include("~/css/font-awesome.css"));

            bundles.Add(new ScriptBundle("~/bundles/ckeditor",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/ckeditor/{0}/ckeditor.js", CKEDITOR_VERSION))
                .Include("~/Scripts/Editors/ckeditor/ckeditor.js"));

            #region Bootstrap
            bundles.Add(new StyleBundle("~/bundles/bootstrap/css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/{0}/css/bootstrap.min.css", BOOTSTRAP_VERSION))
                .Include("~/Content/bootstrap.css"));

            bundles.Add(new StyleBundle("~/bundles/bootstrap/theme",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/{0}/css/bootstrap-theme.min.css", BOOTSTRAP_VERSION))
                .Include("~/Content/bootstrap-theme.css"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap/js",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/{0}/js/bootstrap.min.js", BOOTSTRAP_VERSION))
                .Include("~/Scripts/bootstrap.js"));
            #endregion

            #region jqGrid
            bundles.Add(new StyleBundle("~/bundles/jqgrid.css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/free-jqgrid/{0}/css/ui.jqgrid.min.css", JQGRID_VERSION))
                .Include("~/Scripts/jquery/plugins/jqGrid/css/ui.jqgrid.css"));

            bundles.Add(new StyleBundle("~/bundles/jqgrid.css/plugins/ui.multiselect.css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/free-jqgrid/{0}/plugins/ui.multiselect.css", JQGRID_VERSION))
                .Include("~/Scripts/jquery/plugins/jqGrid/plugins/ui.multiselect.css"));

            bundles.Add(new ScriptBundle("~/bundles/jqgrid.js",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/free-jqgrid/{0}/js/jquery.jqgrid.min.js", JQGRID_VERSION))
                .Include("~/Scripts/jquery/plugins/jqGrid/js/jquery.jqgrid.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqgrid.js/plugins/ui.multiselect.js",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/free-jqgrid/{0}/plugins/ui.multiselect.js", JQGRID_VERSION))
                .Include("~/Scripts/jquery/plugins/jqGrid/plugins/ui.multiselect.js"));

            bundles.Add(new ScriptBundle(String.Format("~/bundles/jqgrid.js/js/i18n/grid.locale-{0}.js", "en"),
                String.Format("//cdnjs.cloudflare.com/ajax/libs/free-jqgrid/{0}/js/i18n/grid.locale-{1}.js", JQGRID_VERSION, "en"))
                .Include(String.Format("~/Scripts/jquery/plugins/jqGrid/js/i18n/grid.locale-{0}.js", "en")));
            #endregion

            #region Timeago
            bundles.Add(new ScriptBundle("~/bundles/timeago.js",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jquery-timeago/{0}/jquery.timeago.min.js", TIMEAGO_VERSION))
                .Include("~/Scripts/jquery/plugins/timeago/jquery.timeago.js"));

            bundles.Add(new ScriptBundle(String.Format("~/bundles/timeago.js/locales/jquery.timeago.{0}.js", "en"))
                .Include(String.Format("~/Scripts/jquery/plugins/timeago/locales/jquery.timeago.{0}.js", "en")));
            #endregion

            #region PNotify 2.0
            bundles.Add(new ScriptBundle("~/bundles/pnotify/js",
                "//cdnjs.cloudflare.com/ajax/libs/pnotify/2.0.0/pnotify.all.min.js")
                .Include("~/Scripts/jquery/plugins/pnotify/pnotify.all.min.js"));

            bundles.Add(new StyleBundle("~/bundles/pnotify/css",
                "//cdnjs.cloudflare.com/ajax/libs/pnotify/2.0.0/pnotify.all.min.css")
                .Include("~/Scripts/jquery/plugins/pnotify/pnotify.all.min.css"));
            #endregion

            #region Timepicker
            bundles.Add(new StyleBundle("~/bundles/timepicker/css",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/{0}/jquery-ui-timepicker-addon.min.css", TIMEPICKER_VERSION))
                .Include("~/Scripts/jquery/plugins/timepicker/dist/jquery-ui-timepicker-addon.css"));

            bundles.Add(new ScriptBundle("~/bundles/timepicker/js",
                String.Format("//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/{0}/jquery-ui-timepicker-addon.min.js", TIMEPICKER_VERSION))
                .Include("~/Scripts/jquery/plugins/timepicker/dist/jquery-ui-timepicker-addon.js"));

            foreach (var item in LANGUAGES) {
                bundles.Add(new ScriptBundle(String.Format("~/bundles/timepicker/js/i18n/jquery-ui-timepicker-{0}.js", item),
                    String.Format("//cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/{0}/i18n/jquery-ui-timepicker-{1}.js", TIMEPICKER_VERSION, item))
                    .Include(String.Format("~/Scripts/jquery/plugins/timepicker/dist/i18n/jquery-ui-timepicker-{0}.js", item)));
            }
            #endregion

            #region qTip
            bundles.Add(new StyleBundle("~/bundles/qtip/css",
                "//cdnjs.cloudflare.com/ajax/libs/qtip2/3.0.3/jquery.qtip.min.css")
                .Include("~/Scripts/jquery/plugins/qtip2/jquery.qtip.min.css"));

            bundles.Add(new ScriptBundle("~/bundles/qtip/js",
                "//cdnjs.cloudflare.com/ajax/libs/qtip2/3.0.3/jquery.qtip.min.js")
                .Include("~/Scripts/jquery/plugins/qtip2/jquery.qtip.min.js"));
            #endregion
        }
    }
}
