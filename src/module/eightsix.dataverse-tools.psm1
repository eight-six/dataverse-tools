[securestring]$Script:AuthToken
$Script:OrgUri = 'missing'
$ApiPath = 'api/data/v9.2'

function CompressJsonForOutput {
    param(
        [string]$Json
    )

    $Json | ConvertFrom-Json | ConvertTo-Json -Depth 99 -Compress
}

function FlattenForOutput {
    param(
        [hashtable]$Hashtable,
        [string[]] $SensitiveKeys = @('Authorization')
    )

    $Copy = [ordered]@{}

    $Headers.Keys | % {
        if ($_ -in $SensitiveKeys) {
            $Copy.Add($_, '*******')
        }
        else {
            $Copy.Add($_, $Headers[$_])
        }
    }
    
    $Ret = $Copy | ConvertTo-Json -Compress

    $Ret
}

function Invoke-ApiRequest {
    param (
        [string]$Action,

        [ValidateSet('GET', 'POST', 'PUT')]
        [string]$Method = 'GET',

        [object]$Body = $null,

        [switch]$Raw
    )
    
    # check - no body with GET

    $Uri = $Script:OrgUri, $ApiPath, $Action -Join '/'
    
    Write-Verbose "Uri: $Uri" -Verbose
    Write-Verbose "Method: $Method" -Verbose

    $Headers = @{
        Authorization      = "Bearer $(Get-AuthToken -AsPlainText)"
        Accept             = 'application/json'  
        'OData-MaxVersion' = '4.0' 
        'OData-Version'    = '4.0'
        'If-None-Match'    = $null
    }

    Write-Verbose (FlattenForOutput $Headers) -Verbose

    $Params = @{
        Uri     = $Uri
        Method  = $Method
        Headers = $Headers    
    }

    if ($null -ne $Body) {
        $Params.Body = $Body

        if ($Body -is [Collections.IDictionary]) {
            Write-Verbose (FlattenForOutPut $Body) -Verbose
        }
        elseif ($Body -is [string]) {
            Write-Verbose (CompressJsonForOutput $Body) -Verbose
        }

        $Headers.Add('Content-Type', 'application/json')
    }

    $Response = Invoke-WebRequest @Params

    $Raw.IsPresent ? $Response.Content : ($Response.Content | ConvertFrom-Json)
}

function Get-AuthToken {
    param (
        [switch]$AsPlainText
    )
    $Creds = Import-Clixml -Path ~/.dataverse-tools

    $Ret = ($AsPlainText.IsPresent ? 
            ($Creds.Password | ConvertFrom-SecureString -AsPlainText) :
            $Creds.Password
    )

    Return $Ret        
}

# https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/retrieve-metadata-name-metadataid
function Get-Entity {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(ParameterSetName = 'ByLogicalName')]
        [string]$LogicalName,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByLogicalName')]
        [string[]]$Select = @(),

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByLogicalName')]
        [string]$Filter,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByLogicalName')]
        [switch]$Raw
    )

    #$select=DisplayName,IsKnowledgeManagementEnabled,EntitySetName
    #$filter=OwnershipType eq Microsoft.Dynamics.CRM.OwnershipTypes'UserOwned'
    if($LogicalName.Length -gt 0){
        $Action = "EntityDefinitions(LogicalName='$LogicalName')"
    } else {
        $Action = "EntityDefinitions"
    }

    if ($Select.Length -gt 0) {
        $Action += "?`$select=$($Select -join ',')"
    }

    if ($Filter.Length -gt 0) {
        $Action += "&`$filter=$($Filter -join ',')"
    }
    Invoke-ApiRequest -Action $Action -Raw:($Raw.IsPresent)
}



# https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/retrieve-metadata-name-metadataid
function Get-EntityAttribute {
    param(
        [string]$EntityName,
        [string]$AttributeName = '*',
        [string[]]$Select = @(),
        
        [switch]$Raw
    )

    $Action = "EntityDefinitions(LogicalName='$EntityName')/Attributes"

    if ($AttributeName -ne '*') {
        $Action += "(LogicalName='$AttributeName')"
    }

    if ($Select.Length -gt 0) {
        $Action += "?`$select=$($Select -join ',')"
    }

    Invoke-ApiRequest -Action $Action -Raw:($Raw.IsPresent)
}

function Get-OrganisationUri {
    param(
    )

    $Script:OrgUri
}

function Get-WhoAmI {
    param()

    Invoke-ApiRequest -Action 'WhoAmI'
}

function New-Entity {
    param(
        [Parameter(ParameterSetName = 'FromJson')]
        [string]$EntityDefinition
    )

    Invoke-ApiRequest -Method 'POST' -Action 'EntityDefinitions' -Body $EntityDefinition
}

function Set-Entity {
    param(
        [Parameter(ParameterSetName = 'FromHashtable')]
        [hashtable]$EntityDefinition,

        [Parameter(Mandatory=$true,ParameterSetName = 'FromJson')]
        [string]$LogicalName,

        [Parameter(Mandatory=$true,ParameterSetName = 'FromJson')]
        [string]$JsonDefinition
        
    )

    if($PSCmdlet.ParameterSetName -eq 'FromHashtable'){
        $LogicalName = $EntityDefinition.LogicalName
        $JsonDefinition = $EntityDefinition | ConvertTo-Json -Depth 99
    }

    Invoke-ApiRequest -Method 'PUT' -Action "EntityDefinitions(LogicalName='$LogicalName')" -Body $JsonDefinition
}

function Remove-Entity {
    throw 'Not implemented'
}

function New-EntityAttribute {
    throw 'Not implemented'

}

function Remove-EntityAttribute {
    throw 'Not implemented'
}

function Set-EntityAttribute {
    throw 'Not implemented'
}


function Set-AuthToken {
    param (
        [securestring]$Token
    )

    #$Password = ConvertFrom-SecureString $Token -AsPlainText
    $Cred = New-Object 'System.Management.Automation.PSCredential' ('<not-used>', $Token)
    $Cred | Export-Clixml -Path ~/.dataverse-tools

}

function Set-OrganisationUri {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ $_ -match 'https://[a-z0-9]+.api.crm[0-9]{0,2}.dynamics.com' })]
        [string]$Uri
    )

    $Script:OrgUri = $Uri
}


function TestyMcTest {

    
}