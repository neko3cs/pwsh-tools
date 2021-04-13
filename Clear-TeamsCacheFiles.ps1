#!pwsh

$TempDirectory = "C:\Users\$($env:USERNAME)\Desktop\teams_cache_backup"
$TeamsCacheDirectoryBase = "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Teams"
$Caches = @(
    "blob_storage"
    "Cache"
    "Code Cache"
    "databases"
    "GPUCache"
    "Local Storage"
    "Service Worker"
    "tmp"
    "logs.txt"
)
$CachePatterns = @(
    @{ Path = "."; Pattern = "old_logs_*.txt" },
    @{ Path = "IndexedDB"; Pattern = "*.ldb" }
)

foreach ($Cache in $Caches) {
    Copy-Item `
        -Path "$TeamsCacheDirectoryBase\$Cache" `
        -Destination "$TempDirectory\$Cache" `
        -Recurse
}

foreach ($Cache in $CachePatterns) {
    Get-ChildItem `
        -Path "$TeamsCacheDirectoryBase\$($Cache.Path)" `
        -Filter "$($Cache.Pattern)" `
        -Recurse

    Get-ChildItem `
        -Path "$TeamsCacheDirectoryBase\$($Cache.Path)" `
        -Filter "$($Cache.Pattern)" `
        -Recurse |
    Copy-Item `
        -Destination "$TempDirectory\$Cache" `
        -Recurse
}

return

foreach ($Cache in $Caches) {
    try {
        Remove-Item `
            -Path "$TeamsCacheDirectoryBase\$Cache" `
            -Recurse   
    }
    catch {
        Write-Host "[$Cache]の削除で失敗しました。手動で復旧してください。" `
            -ForegroundColor Red
        return
    }
}

foreach ($Cache in $Caches) {
    try {
        Get-ChildItem `
            -Path "$TeamsCacheDirectoryBase\$($Cache.Path)" `
            -Filter "$($Cache.Pattern)" `
            -Recurse |
        Remove-Item `
            -Recurse
    }
    catch {
        Write-Host "[$($Cache.Path)\$($Cache.Pattern)]の削除で失敗しました。手動で復旧してください。" `
            -ForegroundColor Red
        return
    }
}
