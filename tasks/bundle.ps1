$ErrorActionPreference = 'Stop'

$BuildDir = "$PSScriptRoot/../build"
$ModuleVersion = $Env:BUILD_MODULE_VERSION ??  '99.99.99'
$ModuleName = 'eight-six.dataverse-tools'
$ModuleBuildPath = "$BuildDir/$ModuleVersion"
$ModuleFilePath = "$ModuleName-v$ModuleVersion.zip"
$ModuleSourcePath = "$PSScriptRoot/../src/modules/eight-six.dataverse-tools"
$BundleFilePath = "$BuildDir/eight-six.dataverse-tools-v$ModuleVersion.zip"

if(!(Test-Path $BuildDir)){
    mkdir $BuildDir
}

if(!(Test-Path $ModuleBuildPath)){
    mkdir $ModuleBuildPath
}

Update-ModuleManifest -Path "$ModuleSourcePath/$ModuleName.psd1" -ModuleVersion $ModuleVersion 

Copy-Item "$ModuleSourcePath/*" $ModuleBuildPath -recurse

Compress-Archive -path "$ModuleBuildPath"  -Destination "$BuildDir/$ModuleFilePath" -Force -verbose

Remove-Item $ModuleBuildPath -recurse -force

# Compress-Archive -path "$BuildDir/*" -Destination $BundleFilePath -Force -verbose




