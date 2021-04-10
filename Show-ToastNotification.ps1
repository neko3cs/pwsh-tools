# Windows PowerShell

<#
.SYNOPSIS
    Show Windows 10 Toast.
.DESCRIPTION
    Show Windows 10 Toast.
    Toast is simple that consist of title and message.
    This script can run only Windows Powershell; not PowerShell Core. 
.PARAMETER Title
    Toast title.
.PARAMETER Message
    Toast message.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String] $Title,
    [Parameter(Mandatory)]
    [String] $Message
)

if ($PSEdition -ne "Desktop") {
    Write-Host "Run only Windows PowerShell." `
        -ForegroundColor Red
}

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

function New-ToastUiXml {
    param (
        [string] $Title,
        [string] $Message
    )

    $content = @"
<?xml version="1.0" encoding="utf-8"?>
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>$($Title)</text>
            <text>$($Message)</text>
        </binding>
    </visual>
</toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($content)

    return $xml
}

function Show-Toast {
    param (
        [Windows.Data.Xml.Dom.XmlDocument] $Xml
    )

    $toast = New-Object Windows.UI.Notifications.ToastNotification $Xml
    $app_id = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app_id).Show($toast)   
}

$xml = New-ToastUiXml `
    -Title $Title `
    -Message $Message

Show-Toast -Xml $xml
