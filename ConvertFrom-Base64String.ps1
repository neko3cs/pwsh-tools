#!pwsh

param(
    [string]$Base64String
)

$bytes = [System.Convert]::FromBase64String($Base64String);
return [System.Text.Encoding]::UTF8.GetString($bytes);
