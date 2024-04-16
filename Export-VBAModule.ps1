#Requires -PSEdition Core

<#
.SYNOPSIS
  Excelファイルに保存されたVBAコードを取得します。
.DESCRIPTION
  指定のExcelファイルからVBAコードを取得します。
  VBAコードはExcelファイルと同様のディレクトリへ保存されます。
.PARAMETER ExcelPath
  取得したいVBAコードが含まれるExcelファイルのパスを指定します。
#>
param(
  [string]$ExcelPath
)

$excel = New-Object -ComObject Excel.Applicaiton

$excel.$Workbooks.Open($ExcelPath) |
ForEach-Object {
  $_.VBProject.Components |
  ForEach-Object {
    $exportFileName = Join-Path (Get-ChildItem $ExcelPath).Parent.FullName "$($_.Name).bas"
    $_.Export($exportFileName)
  }
}

$excel.Quit()

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
Remove-Variable -Name excel
