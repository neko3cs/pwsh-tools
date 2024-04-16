#Requires -PSEdition Core

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
