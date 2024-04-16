#Requires -PSEdition Core

<#
.SYNOPSIS
    ExcelファイルからSQL Server向けのテストデータ投入用SQLファイルを出力します。
.DESCRIPTION
    ExcelファイルからSQL Server向けのテストデータ投入用SQLファイルを出力します。
.PARAMETER Path
    Excelファイルのパスを指定します。
.PARAMETER OutputSqlFilePath
    SQLファイルの出力先パスを指定します。
    デフォルトでは '.\TestData.sql' となっています。
#>
param(
    [string]$Path,
    [string]$OutputSqlFilePath = ".\TestData.sql"
)

function Get-DeleteStatement {
    param (
        $TargetTable
    )
    return [string]::Join("`n",
        @(
            "-- $($TargetTable.LogicalName)"
            "delete from $($TargetTable.PhysicalName)"
            ""
        ))
}
function Set-SingleQuate {
    param (
        [string]$Value
    )
    if ($Value.Trim() -eq "NULL") {
        return $Value.Trim()
    }
    return "'$Value'"
}

if ([string]::IsNullOrEmpty($Path)) {
    help $MyInvocation.MyCommand.Path
    exit
}

$TargetDatabase = ""
$TargetTables = @(
    @{ LogicalName = ""; PhysicalName = ""; IdentityInsert = $false; },
    @{ LogicalName = ""; PhysicalName = ""; IdentityInsert = $true; },
    @{ LogicalName = ""; PhysicalName = ""; IdentityInsert = $false; }
)
$StartRow = 1
$StartColumn = 1

$DeleteSqlFilePath = ".\DeleteTestData.sql"
if (Test-Path $DeleteSqlFilePath) {
    Remove-Item -Force $DeleteSqlFilePath
}
"use $TargetDatabase`n" |
Out-File `
    -FilePath $DeleteSqlFilePath `
    -Encoding utf8
foreach ($TargetTable in $TargetTables) {
    Get-DeleteStatement $TargetTable |
    Out-File `
        -FilePath $DeleteSqlFilePath `
        -Append `
        -Encoding utf8
}

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

    "/* `n`t$($TargetTable.LogicalName)`n*/" |
    Out-File `
        -FilePath $OutputSqlFilePath `
        -Append `
        -Encoding utf8

    if ($TargetTable.IdentityInsert) {
        "set identity_insert $($TargetTable.PhysicalName) on;" |
        Out-File `
            -FilePath $OutputSqlFilePath `
            -Append `
            -Encoding utf8
    }

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

    if ($TargetTable.IdentityInsert) {
        "set identity_insert $($TargetTable.PhysicalName) off;" |
        Out-File `
            -FilePath $OutputSqlFilePath `
            -Append `
            -Encoding utf8
    }

    "`n`n" |
    Out-File `
        -FilePath $OutputSqlFilePath `
        -Append `
        -Encoding utf8
}
