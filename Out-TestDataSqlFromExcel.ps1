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
    @{ LogicalName = ""; PhysicalName = ""; },
    @{ LogicalName = ""; PhysicalName = ""; },
    @{ LogicalName = ""; PhysicalName = ""; }
)
$StartRow = 5
$StartColumn = 2

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
        $Sql = "insert into $($TargetTable.PhysicalName) values ("
        
        # FIXME: 正しい順番で並ばないので直す
        $ValuesClause = $Props |
        ForEach-Object {
            return Set-SingleQuate `
                -Value $Record.$_
        } |
        Join-String `
            -Separator ", "

        $Sql += "$ValuesClause);"

        $Sql |
        Out-File `
            -FilePath $OutputSqlFilePath `
            -Append `
            -Encoding utf8

        exit
    }

    Out-File `
        -FilePath $OutputSqlFilePath `
        -Append `
        -Encoding utf8
}
