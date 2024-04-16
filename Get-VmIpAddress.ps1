#Requires -PSEdition Core
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Hyper-Vで定義された仮想マシンのIPv4アドレスを取得します。
.DESCRIPTION
  指定された名称のHyper-Vで定義された仮想マシンのIPv4アドレスを取得します。
.PARAMETER VMName
  仮想マシンの名前を指定します。
.OUTPUTS
  指定した名前の仮想マシンのIPv4アドレスを返します。
#>
param(
  [string]$VMName
)

$IPv4_PATTERN = '\b(?:\d{1,3}\.){3}\d{1,3}\b'
$isRunning = Get-VM |
Where-Object Name -eq $VMName |
Select-Object -First 1 |
ForEach-Object { $_.State -eq 'Running' }

if (-not $isRunning) {
  throw "$VMName is not running."
}
$IpAddress = Get-VM |
Where-Object Name -eq $VMName |
Select-Object -ExpandProperty NetworkAdapters |
Select-Object -ExpandProperty IPAddresses |
Where-Object { $_ -Match $IPv4_PATTERN }

return $IpAddress
