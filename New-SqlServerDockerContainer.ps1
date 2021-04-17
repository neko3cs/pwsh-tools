#!pwsh

$SqlServerVersion = "2019-latest"
$SaPassword = "P@ssword!"

docker run `
    --name mssql `
    -d `
    -p 1433:1433 `
    -e "ACCEPT_EULA=Y" `
    -e "SA_PASSWORD=$SaPassword" `
    -e "MSSQL_PID=Developer" `
    mcr.microsoft.com/mssql/server:$SqlServerVersion
