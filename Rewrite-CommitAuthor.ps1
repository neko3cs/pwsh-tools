# PowerShell Core

$User = ""
$EMail = ""

$commits = @(
    ""
)

# FIXME: git filter-branchは古いから使うなみたいな警告が出てログが書き換わらない
foreach ($commit in $commits) {
    git filter-branch -f --env-filter `
        "GIT_AUTHOR_NAME='${User}'; GIT_AUTHOR_EMAIL='${EMail}'; GIT_COMMITTER_NAME='${User}'; GIT_COMMITTER_EMAIL='${EMail}';" `
        $commit
}
