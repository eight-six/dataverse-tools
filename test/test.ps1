import-module .\src\module\eightsix.dataverse-tools.psd1 -Force
Set-DvOrganisationUri -Uri 'https://org2cb657d8.api.crm11.dynamics.com'
Set-DvAuthToken -Token (read-host -AsSecureString 'token')
# Get-DvWhoAmI 
Get-DvEntity -LogicalName 'cr86f_thing' -select 'LogicalName', 'SchemaName' 


