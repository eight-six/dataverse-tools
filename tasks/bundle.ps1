$ErrorActionPreference = 'Stop'

$BuildDir = "$PSScriptRoot/../build"
$ModuleVersion = $Env:BUILD_MODULE_VERSION ??  '99.99.99'
$ModuleName = 'eight-six.dataverse-tools'
$ModuleBuildPath = "$BuildDir/$ModuleVersion"
# $ModuleFilePath = "$ModuleName-v$ModuleVersion.zip"
$BundleFilePath = "$BuildDir/$ModuleName-v$ModuleVersion.zip"

Compress-Archive -path "$ModuleBuildPath"  -Destination "$BundleFilePath" -Force -verbose





