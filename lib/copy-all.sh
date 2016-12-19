#!/bin/bash

SSBASEDIR=~/Projects/ServiceStack/netcore

LIBDIR=$(pwd)
LIB11=${LIBDIR}/netstandard1.1
LIB13=${LIBDIR}/netstandard1.3
LIB16=${LIBDIR}/netstandard1.6
cd ${SSBASEDIR}

cp ServiceStack.Text/src/ServiceStack.Text/bin/Release/netstandard1.1/* ${LIB11}
cp ServiceStack.Text/src/ServiceStack.Text/bin/Release/netstandard1.3/* ${LIB13}
cp ServiceStack/src/ServiceStack.Interfaces/bin/Release/netstandard1.1/* ${LIB11}
cp ServiceStack/src/ServiceStack.Client/bin/Release/netstandard1.1/ServiceStack.Client.* ${LIB11}
cp ServiceStack/src/ServiceStack.Client/bin/Release/netstandard1.6/ServiceStack.Client.* ${LIB16}
cp ServiceStack/src/ServiceStack.Common/bin/Release/netstandard1.3/ServiceStack.Common.* ${LIB13}
cp ServiceStack/src/ServiceStack/bin/Release/netstandard1.6/ServiceStack.dll ${LIB16}
cp ServiceStack/src/ServiceStack/bin/Release/netstandard1.6/ServiceStack.pdb ${LIB16}
cp ServiceStack/src/ServiceStack.Mvc/bin/Release/netstandard1.6/ServiceStack.Mvc.* ${LIB16}
cp ServiceStack.OrmLite/src/ServiceStack.OrmLite/bin/Release/netstandard1.3/ServiceStack.OrmLite.* ${LIB13}
cp ServiceStack.OrmLite/src/ServiceStack.OrmLite.Sqlite/bin/Release/netstandard1.3/ServiceStack.OrmLite.Sqlite.* ${LIB13}
cp ServiceStack.OrmLite/src/ServiceStack.OrmLite.SqlServer/bin/Release/netstandard1.3/ServiceStack.OrmLite.SqlServer.* ${LIB13}
cp ServiceStack.OrmLite/src/ServiceStack.OrmLite.PostgreSQL/bin/Release/netstandard1.3/ServiceStack.OrmLite.PostgreSQL.* ${LIB13}
