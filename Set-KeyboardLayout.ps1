#!pwsh
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Set Keyboard Layout.
.DESCRIPTION
    Set Keyboard Layout.
    Select Layout in English or Japanese, so Change Keyboard Layout after reboot.
.PARAMETER Layout
    Layout of Keyboard. Select English or Japanese.
#>

param(
    [ValidateSet("English", "Japanese")]
    [string]$Layout
)

if ([string]::IsNullOrEmpty($Layout)) {
    help $MyInvocation.MyCommand.Path
}

if ($Layout -eq "English") {
    $ModeSet = @{
        LayerDriverJPN             = "kbd101.dll";
        OverrideKeyboardIdentifier = "PCAT_101KEY";
        OverridekeyboardSubtype    = "0"
    }
}
elseif ($Layout -eq "Japanese") {
    $ModeSet = @{
        LayerDriverJPN             = "kbd106.dll";
        OverrideKeyboardIdentifier = "PCAT_106KEY";
        OverridekeyboardSubtype    = "2"
    }
}

Set-ItemProperty HKLM:\System\CurrentControlSet\Services\i8042prt\Parameters `
    -Name "LayerDriver JPN" `
    -Value $ModeSet.LayerDriverJPN
Set-ItemProperty HKLM:\System\CurrentControlSet\Services\i8042prt\Parameters `
    -Name "OverrideKeyboardIdentifier" `
    -Value $ModeSet.OverrideKeyboardIdentifier
Set-ItemProperty HKLM:\System\CurrentControlSet\Services\i8042prt\Parameters `
    -Name "OverridekeyboardSubtype" `
    -Value $ModeSet.OverridekeyboardSubtype
    
Write-Host "Change layout to $Layout."
Write-Host "Please reboot...`n"
