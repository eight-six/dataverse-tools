$ErrorActionPreference = "Stop"

Import-Module .\src\modules\eight-six.dataverse-tools\ -Force

if($null -eq $env:DVT_ENVIRONMENT){
    throw "`$Env:DVT_ENVIRONMENT is not set. Please set it to the name of a defined environment. Use Get-DvEnvironment to see a list of defined environments."
}

Select-DvEnvironment -FriendlyName $env:DVT_ENVIRONMENT
Get-DvWhoAmI | Format-List