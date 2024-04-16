#Requires -PSEdition Core
#Requires -RunAsAdministrator

param(
  [string]$VMName
)

$IPv4_PATTERN = '\b(?:\d{1,3}\.){3}\d{1,3}\b'

$IpAddress = Get-VM |
Where-Object Name -eq $VMName |
Select-Object -ExpandProperty networkadapters |
Select-Object -ExpandProperty ipaddresses |
Where-Object { $_ -Match $IPv4_PATTERN }

return $IpAddress
