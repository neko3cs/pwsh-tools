# PowerShell Core

param (
    [switch]$Help
)

[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null

function Write-Usage {
    echo "usage:"
    echo "  ./ExtractFrom-DeadlineXdl.ps1"
    echo "  Locate this script with *.xdl files output from SSMS."
    echo ""
    echo "option:"
    echo "  -Help: Write this usage."
}

$OutFileName = (Join-Path $PSScriptRoot "out.sql")
if (Test-Path($OutFileName)) {
    Remove-Item $OutFileName -Force
}

function Write-ResultFile {
    Param (
        [Parameter(ValueFromPipeline)]
        [psobject]$WrittenObject,
        [switch]$NewLine
    )
    if ($NewLine) {
        $WrittenObject = ""
    }
    $WrittenObject | Out-File -FilePath $OutFileName -Append
}

function ConvertFrom-DeallockXdl {
    param (
        [string]$XmlFileName
    )
    "-- $XmlFileName" | Write-ResultFile

    $Xml = [System.Xml.Linq.XDocument]::Load((Join-Path $PSScriptRoot $XmlFileName))
    $XProcessLists = $Xml.Element("deadlock-list").Element("deadlock").Elements("process-list")

    foreach ($XProcessList in $XProcessLists) {
        $Processes = $XProcessList.Elements("process")
        foreach ($XProcess in $Processes) {
            $XFrames = $XProcess.Element("executionStack").Elements("frame")
            foreach ($XFrame in $XFrames) {
                $XFrame.Value | Write-ResultFile
                Write-ResultFile -NewLine
            }
            $XProcess.Element("inputbuf").Value | Write-ResultFile
            Write-ResultFile -NewLine
        }
    }
}

$XmlFileNames = Get-ChildItem $PSScriptRoot -Name *.xdl -File
foreach ($XmlFileName in $XmlFileNames) {    
    ConvertFrom-DeallockXdl -XmlFileName $XmlFileName
}
