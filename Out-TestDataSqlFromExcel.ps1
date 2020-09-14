#!pwsh

<#
.SYNOPSIS
    Output SQL File for SQL Server from Excel.
.DESCRIPTION
    Output SQL File for SQL Server from Excel.
    If you need test data of system development, you can create with table at Excel.
.PARAMETER Path
    Path of test data Excel.
.PARAMETER OutputSqlFilePath
    Path of  test data sql file made with Excel.
#>

param(
    [string]$Path,
    [string]$OutputSqlFilePath = ".\TestData.sql"
)

function Set-SingleQuate {
    param (
        [string]$Value
    )
    if ($Value -eq "NULL") {
        return $Value
    }
    return "'$Value'"
}

$TargetDatabase = ""
$TargetTables = @(
    # LogicalName: Excel SheetName
    # PhysicalName: Database Table Name
    @{ LogicalName = ""; PhysicalName = ""; },
    @{ LogicalName = ""; PhysicalName = ""; },
    @{ LogicalName = ""; PhysicalName = ""; }
)
$StartRow = 1
$StartColumn = 1

if (Test-Path $OutputSqlFilePath) {
    Remove-Item -Force $OutputSqlFilePath
}

"use $TargetDatabase;`n" |
Out-File `
    -FilePath $OutputSqlFilePath `
    -Append `
    -Encoding utf8

foreach ($TargetTable in $TargetTables) {
    $Table = Import-Excel $Path `
        -WorksheetName $TargetTable.LogicalName `
        -StartRow $StartRow `
        -StartColumn $StartColumn

    "-- $($TargetTable.PhysicalName)" |
    Out-File `
        -FilePath $OutputSqlFilePath `
        -Append `
        -Encoding utf8

    $Props = $Table |
    Get-Member `
        -MemberType Properties |
    Select-Object `
        -ExpandProperty Name

    foreach ($Record in $Table) {
        $ColumnClause = $Props |
        ForEach-Object { "[$_]" } |
        Join-String `
            -Separator ", "
        
        $ValuesClause = $Props |
        ForEach-Object {
            Set-SingleQuate `
                -Value $Record.$_
        } |
        Join-String `
            -Separator ", "
        
        "insert into $($TargetTable.PhysicalName) ($ColumnClause) values ($ValuesClause);" |
        Out-File `
            -FilePath $OutputSqlFilePath `
            -Append `
            -Encoding utf8
    }

    Out-File `
        -FilePath $OutputSqlFilePath `
        -Append `
        -Encoding utf8
}
