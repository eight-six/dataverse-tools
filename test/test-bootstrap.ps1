$ErrorActionPreference = "Stop"

if($null -eq $env:PWAPPS_ENVIRONMENT_URI){
    throw "`$Env:PWAPPS_ENVIRONMENT_URI is not set. Please set it to the URI of your Power Apps environment."
}

import-module .\src\module\eightsix.dataverse-tools.psd1 -Force
Set-DvOrganisationUri -Uri  "$env:PWAPPS_ENVIRONMENT_URI"
Get-DvWhoAmI 
