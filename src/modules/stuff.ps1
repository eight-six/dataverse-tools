
# function Set-ServicePrincipalCreds{
#     param(
#         [Parameter(Mandatory = $true, Position = 0)]
#         [pscredential]$Credential
#     )
    
#     $Script:Credential = $Credential
# }

# function Connect-Environment {
#     param(
#         [Parameter(Mandatory = $true, Position = 0)]
#         [ValidatePattern('[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}')]
#         [string]$ClientId,
#         # add paramater for client secret
    
#         [Parameter(Mandatory = $false, Position = 1)]
#         [ValidateNotNullOrWhiteSpace()]
#         [securestring]$ClientSecret
#     )
    
#     $Environment = Get-DvEnvironment -Current

#     if($null -eq $Environment){
#         throw 'No environment is currently selected. Please select an environment with Select-Environment'
#     }   

#     $EnvironmentUri = $Environment.Uri
#     $TokenEndpoint = "https://login.microsoftonline.com/common/oauth2/authorize?resource=$EnvironmentUri"

#     # Add System.Web for urlencode
#     Add-Type -AssemblyName System.Web

#     # Create body
#     $Body = @{
#         client_id     = $ClientId
#         client_secret = (ConvertFrom-SecureString $ClientSecret -AsPlainText)
#         scope         = $Scope
#         grant_type    = 'client_credentials'
#     }

#     $Params = @{
#         Uri         = $TokenEndpoint
#         ContentType = 'application/x-www-form-urlencoded'
#         Method      = 'POST'
#         Body        = $Body
#     }

#     # Request the token!
#     $Request = Invoke-RestMethod @Params 
#     $Request
# }

# function Get-AuthToken {
#     param (
#         [switch]$AsPlainText
#     )

#     if(!(Test-Path  $Script:TokenPath) -and ($null -ne $Env:DV_PROMPT_FOR_AUTH_TOKEN) -and ($Env:DV_PROMPT_FOR_AUTH_TOKEN -eq 'true')){
#         Set-AuthToken -Prompt
#     }

#     $Creds = Import-Clixml -Path $Script:TokenPath

#     $Ret = ($AsPlainText.IsPresent ? 
#             ($Creds.Password | ConvertFrom-SecureString -AsPlainText) :
#             $Creds.Password
#     )

#     Return $Ret        
# }
# 