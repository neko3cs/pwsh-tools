#Requires -PSEdition Core
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  hostsファイルに定義されたホスト情報を更新します。
.DESCRIPTION
  hostsファイルに定義された指定のホスト名のIPアドレスを指定のIPアドレスに書き換えます。
  このスクリプトを実行するためには事前にhostsファイルに指定のホスト名のホスト情報が設定されている必要があります。
.PARAMETER IPAddress
  更新後のIPv4アドレスを指定します。
.PARAMETER HostName
  更新対象のホスト名を指定します。
#>
param(
  [Parameter(Mandatory, ValueFromPipeline)]
  [string]$IPAddress,
  [string]$HostName
)

$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$hostsContent = Get-Content -Path $hostsPath

$contained = $hostsContent |
Select-String -Pattern "[\s\S]*$HostName" -Quiet

if (-not $contained) {
  Write-Host "Error: 事前にhostsファイルに $HostName を設定してください。" -ForegroundColor Red
  exit 1
}
else {
  $hostsContent -replace "[\s\S]*$HostName", "$IPAddress $HostName" |
  Out-File -FilePath $hostsPath -Encoding utf8BOM
}
