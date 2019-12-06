# PowerShell Core

Param(
    [Parameter(Mandatory)]
    [string]$Value,
    [switch]$Decrypt
)

# TODO: usage書く

function Use-Disposable {
    param (
        [System.IDisposable]$disposable,
        [scriptblock]$block
    )
    try {
        &$block($disposable)
    }
    finally {
        if ($disposable) { 
            $disposable.Dispose() 
        }
    }
}

# TODO: 自動生成するオプションを作る
# 以下内容のCrypt-SecretStrings.secretファイルが必要
#   { DesKey: "{TripleDES共有キー}", DesIv: "{TripleDES初期化ベクター}" }
# 参照：https://docs.microsoft.com/ja-jp/dotnet/standard/security/generating-keys-for-encryption-and-decryption
$Secret = Get-Content -Path Crypt-SecretStrings.secret | ConvertFrom-Json

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
