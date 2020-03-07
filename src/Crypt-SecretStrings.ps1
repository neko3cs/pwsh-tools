# PowerShell Core

<#
.SYNOPSIS
    Encrypt or Decrypt with Triple DES.
    Default is Encryption.
.DESCRIPTION
    1. Encryption
        Encryption plane string with Triple DES Algorithm.
        Default is encryption.
    2. Decryption
        Decryption encrypted string by Triple DES Algorithm with "-Decrypt" parameter.
.PARAMETER Decrypt
    Decrypt '-Value' option string.
.PARAMETER Value
    The string you want to crypt.
#>

Param(
    [string]$Value,
    [switch]$Decrypt
)

begin {
    Import-Module ./Use-Disposable.psm1

    function New-SecretKeyAndIV {
        $TripleDESCryptoServiceProvider = New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider
        $TripleDESCryptoServiceProvider.GenerateKey();
        $TripleDESCryptoServiceProvider.GenerateIV();

        return @{
            DesKey = [Convert]::ToBase64String($TripleDESCryptoServiceProvider.Key)
            DesIv  = [Convert]::ToBase64String($TripleDESCryptoServiceProvider.IV)
        }
    }

    function Get-EncriptString {
        Param(
            [string]$Value,
            [object]$Secret
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
            [string]$Value,
            [object]$Secret
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
}
process {
    if ($Help -or [string]::IsNullOrEmpty($Value)) {
        Write-Usage
        exit
    }

    $Secret = $null
    $SecretFileName = "Crypt-SecretStrings.secret"
    if ([System.IO.File]::Exists($SecretFileName)) {
        $Secret = Get-Content -Path $SecretFileName | ConvertFrom-Json
    }
    else {
        # HACK: キーを環境変数に持ってモジュール化するか検討
        $Secret = New-SecretKeyAndIV
        $Secret | ConvertTo-Json | Out-File -FilePath $SecretFileName
    }
    
    if ($Decrypt) {
        return Get-DecriptString -Value $Value -Secret $Secret
    }
    else {
        return Get-EncriptString -Value $Value -Secret $Secret
    }
}
