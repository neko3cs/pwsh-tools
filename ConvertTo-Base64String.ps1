#!pwsh

param(
    [string]$RawString
)

$bytes = [System.Text.Encoding]::UTF8.GetBytes($RawString);
return [System.Convert]::ToBase64String($bytes);
