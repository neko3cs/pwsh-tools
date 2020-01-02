# PowerShell Core

Param (
    [string]$Server,
    [string]$User,
    [string]$Password,
    [string]$Sql
)

Import-Module ./Modules/Use-Disposable.psm1

[object]$ConnectionString = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
$ConnectionString["Data Source"] = $Server
$ConnectionString["User Id"] = $User
$ConnectionString["Password"] = $Password

Use-Disposable (New-Object System.Data.SqlClient.SqlConnection($ConnectionString)) {
    Param (
        $connection
    )
    $connection.Open()
    Use-Disposable (New-Object System.Data.SqlClient.SqlCommand($Sql, $connection)) {
        Param (
            $command
        )
        $command.ExecuteNonQuery()
    }
}
