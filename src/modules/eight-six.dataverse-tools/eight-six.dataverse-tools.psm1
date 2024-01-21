$Script:ApiPath = 'api/data/v9.2'

function Invoke-ApiRequest {
    param (
        [string]$Action,

        [ValidateSet('GET', 'POST', 'PUT')]
        [string]$Method = 'GET',

        [object]$Body = $null,

        [switch]$Raw
    )
    
    $Environment = Get-Environment -Current

    if ($null -eq $Environment) {
        throw 'No environment selected. Use Select-Environment to select one.'
    }
    
    $AuthToken = Get-AuthToken -ResourceUrl $Environment.Uri

    # check - no body with GET

    $Uri = $Environment.ApiUri, $Action -Join '/'
    
    Write-Verbose "Uri: $Uri" -Verbose
    Write-Verbose "Method: $Method" -Verbose

    $Headers = @{
        Authorization      = "Bearer $AuthToken"
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


# function Set-AuthToken {
#     param (
#         [Parameter(ParameterSetName='WithToken', Mandatory=$true)]
#         [securestring]$Token,

#         [Parameter(ParameterSetName='Prompt', Mandatory=$true)]
#         [switch]$Prompt
#     )

#     if($PSCmdlet.ParameterSetName -eq 'Prompt'){
#         $Token = read-host -AsSecureString -Prompt 'Token'
#     }

#     $Cred = New-Object 'System.Management.Automation.PSCredential' ('<not-used>', $Token)
#     $Cred | Export-Clixml -Path $Script:TokenPath

# }

function Test-McTestFace {
    param (
        
    )

    Write-Verbose "$($MyInvocation.MyCommand.ScriptBlock.Module)" -Verbose
}
