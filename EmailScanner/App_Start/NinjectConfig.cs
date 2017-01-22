using log4net;
using Microsoft.AspNet.SignalR;
using Ninject;
using Ninject.Web.Mvc;
using Owin;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Dependencies;
using System.Web.Security;

namespace EmailScanner.App_Start
{
    public static class NinjectConfig
    {
        private static IKernel _kernel;

        /// <summary>
        /// This is called at OWIN startup
        /// </summary>
        /// <param name="app"></param>
        /// <returns>Ninject kernel</returns>
        public static IKernel Configuration(IAppBuilder app) {
            if (_kernel == null) {
                // Creates the kernel that will manage the application
                var kernel = new StandardKernel();

                Configuration(kernel);
            }

            return _kernel;
        }

        /// <summary>
        /// This is called at Global.asax
        /// </summary>
        /// <param name="kernel">Ninject kernel</param>
        public static void Configuration(IKernel kernel) {
            // MVC default dependency resolver
            System.Web.Mvc.DependencyResolver.SetResolver(
                new NinjectDependencyResolver(kernel));

            // System.Web default dependency resolver
            GlobalConfiguration.Configuration.DependencyResolver
                = System.Web.Mvc.DependencyResolver.Current.ToServiceResolver();

            // SignalR default dependency resolver
            GlobalHost.DependencyResolver = new Microsoft.AspNet
                .SignalR.Ninject.NinjectDependencyResolver(kernel);

            RegisterServices(kernel);

            // store the instance for the OWIN startup
            _kernel = kernel;
        }

        /// <summary>
        /// Load your modules or register your services here!
        /// </summary>
        /// <param name="kernel">The kernel.</param>
        public static void RegisterServices(IKernel kernel) {
            kernel.Bind<ILog>().ToMethod(context => LogManager.GetLogger(
                context.Request.Target.Member.ReflectedType));

            kernel.Load(Assembly.GetExecutingAssembly());
            kernel.Load(Assembly.GetAssembly(typeof(
                System.Services.EmailStorage.EmailStorageModule)));
        }
    }

    public class ServiceResolverAdapter : System.Web.Http.Dependencies.IDependencyResolver
    {
        private readonly System.Web.Mvc.IDependencyResolver dependencyResolver;

        public ServiceResolverAdapter(System.Web.Mvc.IDependencyResolver dependencyResolver) {
            if (dependencyResolver == null)
                throw new ArgumentNullException("dependencyResolver");

            this.dependencyResolver = dependencyResolver;
        }

        public object GetService(Type serviceType) {
            return dependencyResolver.GetService(serviceType);
        }

        public IEnumerable<object> GetServices(Type serviceType) {
            return dependencyResolver.GetServices(serviceType);
        }

        public IDependencyScope BeginScope() {
            // This example does not support child scopes, so we simply return 'this'.
            return this;
        }

        public void Dispose() {
            // When BeginScope returns 'this', the Dispose method must be a no-op.
        }
    }

    public static class ServiceResolverExtensions
    {
        public static System.Web.Http.Dependencies.IDependencyResolver ToServiceResolver(this System.Web.Mvc.IDependencyResolver dependencyResolver) {
            return new ServiceResolverAdapter(dependencyResolver);
        }
    }
}