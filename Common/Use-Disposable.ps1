# PowerShell Core

# 
# using dispose like C#
# 

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
