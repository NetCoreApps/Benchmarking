using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using ServiceStack;

namespace WebApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            IPAddressExtensions.AccessNetworkInterface = false;

            var host = new WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
//                .UseIISIntegration()
                .UseStartup<Startup>()
	        	.UseUrls("http://*:5051")
                .Build();

            host.Run();
        }
    }
}
