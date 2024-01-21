$ErrorActionPreference = 'Stop'

import-module .\src\modules\eight-six.dataverse-tools\ -Force
Select-DvEnvironment -FriendlyName 'client-demo-dev'
Get-DvWhoAmI 
#Get-DvEntity -LogicalName 'cr86f_thing' -select 'LogicalName', 'SchemaName' 


