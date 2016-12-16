using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Funq;
using ServiceStack;
using ServiceStack.Configuration;
using Techempower.ServiceInterface;

namespace WebApp
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit http://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseServiceStack(new AppHost());

            app.Run(context =>
            {
                context.Response.Redirect("/metadata");
                return Task.FromResult(0);
            });
        }
    }

    public class AppHost : AppHostBase
    {
        public AppHost()
            : base("ServiceStack + .NET Core Web App", typeof(TechmeServices).GetAssembly()) { }

        public override void Configure(Container container)
        {
           ConfigApp.AppHost(this, new AppSettings().Get("connection.DbProvider", DbProvider.InMemory));
        }
    }
}
