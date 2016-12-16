using System.IO;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Funq;
using ServiceStack;
using Techempower.ServiceInterface;
using System.Threading;

namespace SelfHost
{
    public class Program
    {
        public static void Main(string[] args)
        {
            IPAddressExtensions.AccessNetworkInterface = false;

            var host = new AppHost()
                .Init()
                .Start("http://*:5052");

            new ManualResetEvent(false).WaitOne();
        }
    }

    public class AppHost : AppSelfHostBase
    {
        public AppHost()
            : base("ServiceStack + .NET Core Self Host", typeof(TechmeServices).GetAssembly()) { }

        public override void Configure(Container container)
        {
        }
    }
}
