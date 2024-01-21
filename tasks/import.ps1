
$ErrorActionPreference = 'Stop'

$ModulePath =  $env:PSModulePath -split ';' | Select-Object -First 1
$ModuleName = 'eight-six.dataverse-tools'
$BuildDir = "$PSScriptRoot/../build"
$ModuleBundleFilePattern = "$BuildDir/$ModuleName-v*.*.*.zip"

$ModuleBundleFile = Get-ChildItem $ModuleBundleFilePattern | Sort-Object -Property 'Name' -Descending | Select-Object -First 1 
$ModuleVersion = $ModuleBundleFile.BaseName.Substring($ModuleName.Length + 2)
$ModuleImportPath = Join-Path -Path $ModulePath -ChildPath $ModuleName
$ModuleImportPathVersion = Join-Path -Path $ModuleImportPath  $ModuleVersion

if(!(Test-Path $ModuleImportPath)){
    mkdir $ModuleImportPath
}

if(Test-Path $ModuleImportPathVersion  -PathType Container){
    Read-Host -Prompt "Module version $ModuleVersion already exists in $ModuleImportPath. Press enter to continue or CTRL+C to cancel"
    Remove-Item $ModuleImportPath -Recurse -Force
}

Expand-Archive -Path $ModuleBundleFile.FullName -DestinationPath $ModuleImportPath -Force -Verbose

