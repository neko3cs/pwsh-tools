# PowerShell Core Module

<#
.SYNOPSIS
Using disposable like C#.

.DESCRIPTION
PowerShell not have using statement.
Use-Disposable function give you experience like C# using statement.

.PARAMETER disposable
Disposable object inheritance IDisposable.

.PARAMETER block
Code script block.

.EXAMPLE
Use-Disposable(New-Object System.IO.MemoryStream) {
    Param(
        $MemoryStream
    )
    ...
}
#>

function Use-Disposable {
    param (
        [System.IDisposable]$disposable,
        [ScriptBlock]$block
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
