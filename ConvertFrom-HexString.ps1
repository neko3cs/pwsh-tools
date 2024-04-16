#Requires -PSEdition Core

<#
.SYNOPSIS
  16進数に変換されている文字列を通常の文字列に変換します。
.DESCRIPTION
  16進数に変換されている文字列を通常の文字列に変換します。
  難読化などの目的で文字列を16進数値に変換することがあります。
  そのような場合に元の値に戻すことが出来ます。
.PARAMETER HexString
  16進数に変換されている文字列を指定します。
.OUTPUTS
  通常の文字列に変換された値を返します。
#>
param(
  [Parameter(Mandatory, ValueFromPipeline)]
  [string]$HexString
)

$stringValue = New-Object System.Text.StringBuilder
foreach ($hex in $HexString.Split('-')) {
  [void]$stringValue.Append(
    [char]::ConvertFromUtf32([System.Convert]::ToInt32($hex, 16))
  )
}

return $stringValue.ToString()
