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

$GitUser = "neko3cs"                     # DEBUG
$GitEmail = "minaton.0722.net@gmail.com" # DEBUG

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
    "d6eee38dcb54effa523d0403f23e4a94da1bcff2"
    # "b28ca164221e40094a2bd7b67e2fa37d16240c8a",
    # "34fc5939f2aa2601642e828f5e6f75c9635f531f",
    # "b26c84d773ccf97dfa39a474fdf3d395d10bd969",
    # "65ed196f66347acc27fa9d8b7c089e34affe43d5",
    # "f73a7cdbb8cd52c3271205554208a591ee0a3550",
    # "0813313aaf577882d58963621da3277491d6ad05",
    # "0b79825b65108a9b6473798238a528832270f56e",
    # "195ef1be6df993131a57cd6ff8c56ecb2dae6219",
    # "72b21dcb2ba8766115e4aac181e2436c06988913",
    # "081f4ff5ccd70f7eca8fc074e26068694f645eb4"
)

# FIXME: git filter-branchは古いから使うなみたいな警告が出てログが書き換わらない
foreach ($commit in $commits) {
    git filter-branch -f --env-filter `
        "GIT_AUTHOR_NAME='${GitUser}'; GIT_AUTHOR_EMAIL='${GitEmail}'; GIT_COMMITTER_NAME='${GitUser}'; GIT_COMMITTER_EMAIL='${GitEmail}';" `
        $commit
}
