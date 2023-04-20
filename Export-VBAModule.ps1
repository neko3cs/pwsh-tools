#Requires -Version 5.1

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
