# PowerShell Core

param (
    # [Parameter(Mandatory)]
    [string]$GitUser,
    # [Parameter(Mandatory)]
    [string]$GitEmail,
    [switch]$Help
)

function Write-Usage {
    echo "usage:"
    #TODO: usage書く
}

$GitUser = ""                     # DEBUG
$GitEmail = "" # DEBUG

if ($Help) {
    Write-Usage
    exit
}
if ([string]::IsNullOrEmpty($GitUser) -and [string]::IsNullOrEmpty($GitEmail)) {
    Write-Usage
    exit
}

# TODO: ここもスクリプト内部で完結させる
$commits = @(
)

# FIXME: git filter-branchは古いから使うなみたいな警告が出てログが書き換わらない
foreach ($commit in $commits) {
    git filter-branch -f --env-filter `
        "GIT_AUTHOR_NAME='${GitUser}'; GIT_AUTHOR_EMAIL='${GitEmail}'; GIT_COMMITTER_NAME='${GitUser}'; GIT_COMMITTER_EMAIL='${GitEmail}';" `
        $commit
}
