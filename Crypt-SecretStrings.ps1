# PowerShell Core

Param(
    [string]$Value,
    [switch]$Decrypt,
    [switch]$Help
)

function Write-Usage {
    Write-Output "usage: "
    Write-Output "      1. .\Crypt-SecretStrings.ps1 -Value <Dcrypted String>"
    Write-Output "      2. .\Crypt-SecretStrings.ps1 -Decrypt -Value <Encrypted String>"
    Write-Output ""
    Write-Output "  -Decrypt: Decrypt '-Value' option string."
    Write-Output "  -Value  : The string you want to crypt."
}

if ($Help -or [string]::IsNullOrEmpty($Value)) {
    Write-Usage
    exit
}

# HACK: キーを環境変数に持ってモジュール化するか検討
$SecretFileName = "Crypt-SecretStrings.secret"
if (-not [System.IO.File]::Exists($SecretFileName)) {
    $TripleDESCryptoServiceProvider = New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider
    $TripleDESCryptoServiceProvider.GenerateKey();
    $TripleDESCryptoServiceProvider.GenerateIV();
    @{
        DesKey = [Convert]::ToBase64String($TripleDESCryptoServiceProvider.Key)
        DesIv  = [Convert]::ToBase64String($TripleDESCryptoServiceProvider.IV)
    } | ConvertTo-Json | Out-File -FilePath $SecretFileName
}
$Secret = Get-Content -Path $SecretFileName | ConvertFrom-Json

function Get-EncriptString {
    Param(
        [string]$Value
    )
    
    Use-Disposable (New-Object System.IO.MemoryStream) {
        Param (
            $MemoryStream
        )

        $TripleDESCryptoServiceProvider = New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider
        $Encryptor = $TripleDESCryptoServiceProvider.CreateEncryptor(
            [Convert]::FromBase64String($Secret.DesKey),
            [Convert]::FromBase64String($Secret.DesIv)
        )

        Use-Disposable (New-Object System.Security.Cryptography.CryptoStream(
                $MemoryStream, $Encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
        ) {
            Param(
                $CryptoStream
            )
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)

            $CryptoStream.Write($bytes, 0, $bytes.Length)
            $CryptoStream.FlushFinalBlock()

            return [Convert]::ToBase64String($MemoryStream.ToArray())
        }
    }
}

function Get-DecriptString {
    Param(
        [string]$Value
    )

    $bytes = [Convert]::FromBase64String($Value)
    Use-Disposable (New-Object System.IO.MemoryStream(, $bytes)) {
        Param (
            $MemoryStream
        )

        $TripleDESCryptoServiceProvider = New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider
        $Encryptor = $TripleDESCryptoServiceProvider.CreateDecryptor(
            [Convert]::FromBase64String($Secret.DesKey),
            [Convert]::FromBase64String($Secret.DesIv)
        )

        Use-Disposable (New-Object System.Security.Cryptography.CryptoStream(
                $MemoryStream, $Encryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)
        ) {
            Param(
                $CryptoStream
            )

            Use-Disposable (New-Object System.IO.StreamReader($CryptoStream)) {
                Param (
                    $StreamReader
                )

                return $StreamReader.ReadLine()
            }
        }
    }
}

if ($Decrypt) {
    Get-DecriptString -Value $Value | Write-Output
}
else {
    Get-EncriptString -Value $Value | Write-Output
}
