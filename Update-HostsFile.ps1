#Requires -PSEdition Core
#Requires -RunAsAdministrator

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
