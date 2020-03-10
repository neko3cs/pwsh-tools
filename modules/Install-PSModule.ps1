#!pwsh

Param(
    [string]$ModuleManifestPath,
    [string]$ModuleBinaryPath
)

$userModulePath = ";C:\Repos\pwsh-tools\modules\"
$psModulePath = (Get-Content $Env:PSModulePath)
if (-not $psModulePath.Contains($userModulePath)) {
    $psModulePath += $userModulePath
    [System.Environment]::SetEnvironmentVariable("PSModulePath", $psModulePath)
}

# https://docs.microsoft.com/ja-jp/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7
