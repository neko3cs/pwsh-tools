# PowerShell Core

Param (
    [string]$Server,
    [string]$User,
    [string]$Password,
    [string]$Sql
)

function Use-Disposable {
    param (
        [System.IDisposable]$disposable,
        [scriptblock]$block
    )
    try {
        &$block($disposable)
    }
    finally {
        if ($disposable) { 
            $disposable.Dispose() 
        }
    }
}

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
