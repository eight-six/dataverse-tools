Get-DvEnvironment | % {Remove-DvEnvironment $_.friendlyName} 

Set-DvEnvironment -FriendlyName 'stvnrs-dev' -Uri 'https://org2cb657d8.crm11.dynamics.com' -Solution 'ingrid' 
Set-DvEnvironment -FriendlyName 'client-demo-dev' -Uri 'https://org5f3af173.crm11.dynamics.com' -Solution 'ingrid' -EnvironmentId '634e74f8-8b0b-ebe3-83cd-7f2e8e4065a6'
Set-DvEnvironment -FriendlyName 'client-demo-build' -Uri 'https://org38a68682.crm11.dynamics.com' -Solution 'ingrid'
Set-DvEnvironment -FriendlyName 'eight-six-default' -Uri 'https://eightsix.crm11.dynamics.com' -Solution 'ingrid'

Add-Environment -FriendlyName 'stvnrs-dev' -Uri 'https://org2cb657d8.crm11.dynamics.com' -Solution 'ingrid' 
Add-Environment -FriendlyName 'client-demo-dev' -Uri 'https://org5f3af173.crm11.dynamics.com' -Solution 'ingrid' -EnvironmentId '634e74f8-8b0b-ebe3-83cd-7f2e8e4065a6'
Add-Environment -FriendlyName 'client-demo-build' -Uri 'https://org38a68682.crm11.dynamics.com' -Solution 'ingrid'
Add-Environment -FriendlyName 'eight-six-default' -Uri 'https://eightsix.crm11.dynamics.com' -Solution 'ingrid'