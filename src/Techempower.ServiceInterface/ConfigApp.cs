using System;
using System.Threading;
using ServiceStack;
using ServiceStack.Configuration;
using ServiceStack.Data;
using ServiceStack.OrmLite;
using ServiceStack.Redis;
//using ServiceStack.Mvc;

namespace Techempower.ServiceInterface
{
    public enum DbProvider
    {
        MySql,
        Sqlite,
        SqlServer,
        PostgreSql,
        InMemory,
    }

    public static class ConfigApp
    {
        public static void AppHost(ServiceStackHost appHost, DbProvider defaultDb = DbProvider.SqlServer)
        {
            //appHost.Plugins.Add(new RazorFormat());

            appHost.Container.Register<IDbConnectionFactory>(CreateDbFactory(defaultDb));
            //appHost.Container.Register<IRedisClientsManager>(c => new PooledRedisClientManager());
        }

        public static OrmLiteConnectionFactory CreateDbFactory(DbProvider defaultDb)
        {
            var appSettings = new AppSettings();
            var dbProvider = appSettings.Get("connection", defaultValue: defaultDb);
            switch (dbProvider)
            {
                case DbProvider.InMemory:
                    return new OrmLiteConnectionFactory(":memory:",
                        SqliteDialect.Provider);

                case DbProvider.SqlServer:
                    return new OrmLiteConnectionFactory(
                        appSettings.Get("connection.sqlserver", "Server=localhost;Database=test;User Id=test;Password=test;"),
                        SqlServerDialect.Provider);

                case DbProvider.PostgreSql:
                    return new OrmLiteConnectionFactory(
                        appSettings.Get("connection.postgresql", "Server=localhost;Port=5432;User Id=test;Password=test;Database=test;Pooling=true;MinPoolSize=0;MaxPoolSize=200"),
                        PostgreSqlDialect.Provider);

/*                case DbProvider.MySql:
                    return new OrmLiteConnectionFactory(
                        appSettings.Get("connection.mysql", "Server=localhost;Database=test;UID=root;Password=test"),
                        MySqlDialect.Provider);
*/
                case DbProvider.Sqlite:
                    return new OrmLiteConnectionFactory(
                        appSettings.Get("connection.sqlite", "db.sqlite"),
                        SqliteDialect.Provider);

                default:
                    throw new NotImplementedException(dbProvider.ToString());
            }
        }

    }
}