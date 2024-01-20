$ErrorActionPreference = "Stop"

if($null -eq $env:DVT_ENVIRONMENT){
    throw "`$Env:DVT_ENVIRONMENT is not set. Please set it to the name of a defined environment."
}

$Env:DV_PROMPT_FOR_AUTH_TOKEN = 'true'
Import-Module .\src\module\eightsix.dataverse-tools.psd1 -Force
Select-DvEnvironment -FriendlyName $env:DVT_ENVIRONMENT
Get-DvWhoAmI | Format-List