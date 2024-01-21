$ErrorActionPreference = 'Stop'

# $BuildDir = "$PSScriptRoot/../build"
$BuildDir = "./build/"
$ModuleVersion = $Env:BUILD_MODULE_VERSION ??  '99.99.99'
$ModuleName = 'eight-six.dataverse-tools'
$ModuleBuildPath = "$BuildDir/tmp"
$ModuleVersionedPath = "$BuildDir/$ModuleVersion"
$ModuleSourcePath = "$PSScriptRoot/../src/modules/eight-six.dataverse-tools"

if(!(Test-Path $BuildDir)){
    mkdir $BuildDir
}

if(!(Test-Path $ModuleBuildPath)){
    mkdir $ModuleBuildPath
}

Copy-Item "$ModuleSourcePath/*" $ModuleBuildPath -recurse
Update-ModuleManifest -Path "$ModuleBuildPath/$ModuleName.psd1" -ModuleVersion $ModuleVersion 


$EnvironmentNameCompleter = {
    param ( 
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    $ConfigFolder = '~/.dataverse-tools'
    $Names = Get-ChildItem -Path $ConfigFolder -Filter '*.environment.xml' | ForEach-Object {
        $_.Name -replace '.environment.xml', ''
    }
    $Names | Where-Object { $_ -like "$wordToComplete*" }
}

$CompleterToken = '{"{{EnvironmentNameCompleter}}"}'
$CompleterText = $EnvironmentNameCompleter.Ast.Extent.Text
$ModuleText = Get-Content "$ModuleBuildPath/nested/environment.psm1" -Raw
$ModuleText = $ModuleText.Replace($CompleterToken, $CompleterText)
$ModuleText | Set-Content "$ModuleBuildPath/nested/environment.psm1"

# needs to be done after manifest update 
Rename-Item $ModuleBuildPath  $ModuleVersion 


