#Requires -PSEdition Core
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Hyper-V仮想マシンが使用するネットワークインターフェースのメトリックを高く設定します。
.DESCRIPTION
    Hyper-V仮想マシンが使用するネットワークインターフェースのメトリックを高く設定します。
    VPN接続時にWSLやHyper-V仮想マシンなどHyper-V技術を使った仮想マシンからPC外のネットワークにアクセスしようとした際に接続できないことがあります。
    そのような場合にVPNクライアントが使用しているネットワークインターフェースのメトリックを上げることでVPN接続時でもアクセスできるようにします。
.PARAMETER VPNInterfaceName
    VPNクライアントのネットワークインターフェース名
    ネットワーク接続の画面にてVPNクライアントツールに表示されているネットワークアダプター名を指定します。
    ネットワーク接続の画面はWin+Rにて「ファイル名を指定して実行」を起動後「ncpa.cpl」を入力し実行することで開きます。
.NOTES
    以下URL先の記事を参照に作成しています。
    https://aquasoftware.net/blog/?p=1472
#>
param(
    [string]$VPNInterfaceName = 'Juniper Networks Virtual Adapter'
)
function Get-NetworkAddress {
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$IPAddress,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]$PrefixLength
    )
    $bitNetworkAddress = [IpAddress]::Parse($IPAddress).Address -band [uint64][BitConverter]::ToUInt32(
        [System.Linq.Enumerable]::Reverse(
            [BitConverter]::GetBytes(
                [uint32](0xFFFFFFFFL -shl (32 - $PrefixLength) -band 0xFFFFFFFFL))), 0)
    return [PSCustomObject]@{
        IPAddress      = $IPAddress
        PrefixLength   = $PrefixLength
        NetworkAddress = ([IpAddress]::new($bitNetworkAddress).IPAddressToString + '/' + $PrefixLength)
    }
}
function Get-NetIPv4Route {
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Interfaces,
        [Parameter(Mandatory)]
        [PSCustomObject]$IPAddresses
    )
    return $Interfaces |
    Get-NetRoute -AddressFamily IPv4 |
    Select-Object -PipelineVariable route |
    Where-Object {
        $IPAddresses |
        Where-Object { $_.NetworkAddress -eq (Get-NetworkAddress $route.DestinationPrefix.Split('/')[0] $_.PrefixLength).NetworkAddress } }
}

$ErrorActionPreference = 'Stop'

$ipAddresses = Get-NetAdapter -IncludeHidden |
Where-Object InterfaceDescription -Match 'Hyper-V Virtual Ethernet Adapter' |
Get-NetIPAddress -AddressFamily IPv4 |
Get-NetworkAddress
$interfaces = Get-NetAdapter -IncludeHidden |
Where-Object InterfaceDescription -Match $VPNInterfaceName

$interfaces |
Set-NetIPInterface `
    -InterfaceMetric 2
Get-NetIPv4Route `
    -Interfaces $interfaces `
    -IPAddresses $ipAddresses |
Set-NetRoute -RouteMetric 6000

return Get-NetIPv4Route `
    -Interfaces $interfaces `
    -IPAddresses $ipAddresses
