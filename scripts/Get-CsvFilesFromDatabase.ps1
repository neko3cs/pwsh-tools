#!pwsh

<#
.SYNOPSIS
Get csv file from SQL Database.

.DESCRIPTION
Get csv file from SQL Database by tables list text file.

.PARAMETER TableListFilePath
File path written target tables name.

    --- File format example ---
    [dbo].[TableA]
    [Hoge].[TableB]
    [Fuga].[TableC]
    ---------------------------

#>

Param(
    [Parameter(Mandatory)]
    [string]$TableListFilePath,
    [Parameter(Mandatory)]
    [string]$OutFolderPath,
    [string]$User,
    [string]$Password,
    [string]$Server,
    [string]$DatabaseName
)

Import-Module -Name SqlServer

if (-not (Test-Path $OutFolderPath)) {
    New-Item -ItemType Directory -Name $OutFolderPath
}

[string[]]$tables = Get-Content $TableListFilePath | Where-Object { $_.Trim() -ne "" }

foreach ($table in $tables) {
    Invoke-Sqlcmd `
        -ServerInstance $server `
        -Database $DatabaseName `
        -Username $User `
        -Password $Password `
        -Query "select * from $table;" |
    # FIXME: DBNull が ConvertTo-Csv で空文字になるので、置換する
    ConvertTo-Csv `
        -Delimiter "," |
    # TODO: ダブルクウォート外しちゃって良いのか？
    ForEach-Object {
        $_ -replace "`"", ""
    } |
    Out-File `
        -FilePath (Join-Path $OutFolderPath "${table}.csv") `
        -Encoding utf8 `
        -Force
}
