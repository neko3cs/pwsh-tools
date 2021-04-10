#!pwsh

$branches = git branch |
Select-String -NotMatch "^\*" |
Select-Object @{ Name = "branch"; Expression = { ($_.Line -as [string]).Trim() } }

$title = "Select branch > "
$message = $branches | Select-Object { "$($branches.IndexOf($branch) + 1): $($_)" }
# FIXME: "Cannot find type [[System.Management.Automation.Host.ChoiceDescription[]]]: verify that the assembly containing this type is loaded."
$options = New-Object [System.Management.Automation.Host.ChoiceDescription[]]
foreach ($branch in $branches) {
    $options.Add((New-Object [System.Management.Automation.Host.ChoiceDescription] "$($branches.IndexOf($branch) + 1)", $branch))
}
$selected = $Host.UI.PromptForChoice($title, $message, $options, $defaultChoice)

git switch "$($branches[$selected])"
