# generated by a tool

function New-EntityDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LogicalName,

        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$DisplayCollectionName,

        [Parameter(Mandatory = $false)]
        [bool]$IsAuditEnabled = $false,

        [object[]]$AttributeDefinition,

        [switch]$AsHashtable
    )

    $Ret = [ordered]@{
        '@odata.type'         = 'Microsoft.Dynamics.CRM.EntityMetadata'  
        OwnershipType         = 'UserOwned'  
        LogicalName           = $LogicalName
        SchemaName            = $SchemaName  
        HasActivities         = $false  
        HasNotes              = $false  
        IsActivity            = $false  
        Description           = [ordered]@{  
            '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'  
            LocalizedLabels = @(  
                [ordered]@{  
                    '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'  
                    Label         = $Description 
                    LanguageCode  = 1033  
                }  
            )  
        }  
        DisplayCollectionName = [ordered]@{  
            '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'  
            LocalizedLabels = @(  
                [ordered]@{  
                    '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'  
                    Label         = $DisplayCollectionName  
                    LanguageCode  = 1033  
                }  
            )  
        }  
        DisplayName           = [ordered]@{  
            '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'  
            LocalizedLabels = @(  
                [ordered]@{  
                    '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'  
                    Label         = $DisplayName  
                    LanguageCode  = 1033  
                }  
            )  
        }  
        Attributes            = $AttributeDefinition
    }

    $AsHashtable.IsPresent ?  $Ret : ($Ret |  ConvertTo-Json -Depth 99)
}

function Get-BasicAttributeDefintion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TypeName,
        [Parameter(Mandatory = $true)]
        [string]$LogicalName,
        [Parameter(Mandatory = $true)]
        [string]$SchemaName
    )

    $Ret = [ordered]@{
        '@odata.type'     = "Microsoft.Dynamics.CRM.$($TypeName)AttributeMetadata"
        LogicalName       = $LogicalName
        SchemaName        = $SchemaName
        AttributeType     = $TypeName
        AttributeTypeName = @{
            Value = "$($TypeName)Type"
        }
    }
    
    $Ret
}

function Add-Description {
    param (
       [object]$Definition,
        [string]$Description
    )

    $Definition.Description = [ordered]@{
        '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'
        LocalizedLabels = @(
            [ordered]@{
                '@odata.type'  = 'Microsoft.Dynamics.CRM.LocalizedLabel'
                'Label'        = $Description
                'LanguageCode' = 1033
            }
        )
    }
}
function Add-DisplayName {
    param (
       [object]$Definition,
        [string]$DisplayName
    )

    $Definition.DisplayName = [ordered]@{
        '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'
        LocalizedLabels = @(
            [ordered]@{
                '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'
                Label         = $DisplayName
                LanguageCode  = 1033
            }
        )
    }
}

function Add-RequiredLevel {
    param (
       [object]$Definition,
        [string]$RequiredLevel
    )

    $Definition.RequiredLevel = [ordered]@{
        Value                      = $RequiredLevel
        CanBeChanged               = $true
        ManagedPropertyLogicalName = 'canmodifyrequirementlevelsettings'
    }
}

function New-StringAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [int]$MaxLength,

        [Parameter(Mandatory = $false)]
        [bool]$IsPrimary = $false,
        
        [Parameter(Mandatory = $false)]
        [string]$FormatName = 'Text',

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'String'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    $Ret += [ordered]@{
        IsPrimaryName = $IsPrimary.ToString().ToLower()
        MaxLength     = $MaxLength
        FormatName    = @{
            Value = $FormatName
        }
    }
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel

    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}

function New-BooleanAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,
    
        [Parameter(Mandatory = $false)]
        [bool]$DefaultValue = $false,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'Boolean'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    # type specific properties
    $Ret.DefaultValue = $DefaultValue
    $Ret += [ordered]@{
        OptionSetType = 'Boolean'
        OptionSet     = [ordered]@{
            TrueOption  = [ordered]@{
                Value = 1
                Label = [ordered]@{
                    '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'
                    LocalizedLabels = @(
                        [ordered]@{
                            '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'
                            Label         = 'True'
                            LanguageCode  = 1033
                            IsManaged     = $false
                        }
                    )
                }
            }
            FalseOption = [ordered]@{
                Value = 0
                Label = [ordered]@{
                    '@odata.type'   = 'Microsoft.Dynamics.CRM.Label'
                    LocalizedLabels = (
                        [ordered]@{
                            '@odata.type' = 'Microsoft.Dynamics.CRM.LocalizedLabel'
                            Label         = 'False'
                            LanguageCode  = 1033
                            IsManaged     = $false
                        }
                    )
                }
            }
        }
    }
    # type specific properties - end
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel
    
    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}

function New-DateTimeAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('DateOnly', 'DateAndTime')]
        [string]$Format = 'DateAndTime',

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'DateTime'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    # type specific properties
    $Ret.Format = $Format
    # type specific properties - end
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel
    
    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}
function New-IntegerAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false)]
        [int]$MinValue = [int]::MinValue,

        [Parameter(Mandatory = $false)]
        [int]$MaxValue = [int]::MaxValue,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'Integer'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    # type specific properties
    $Ret.Format = 'None'
    $Ret.MinValue = $MinValue
    $Ret.MaxValue = $MaxValue
    # type specific properties - end
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel
    
    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}
function New-MemoAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [int]$MaxLength,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('RichText', 'Text')]
        [string]$FormatName = 'Text',

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'Memo'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    $Ret += [ordered]@{
        MaxLength     = $MaxLength
        FormatName    = @{
            Value = $FormatName
        }
    }
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel

    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}

function New-MoneyAttributeDefinition {
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-z][a-z0-9_]+[a-z0-9]$')]
        [string]$LogicalName,
        
        [Parameter(Mandatory = $false)]
        [string]$SchemaName = $LogicalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false)]
        [int]$MinValue = [int]::MinValue,

        [Parameter(Mandatory = $false)]
        [int]$MaxValue = [int]::MaxValue,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'SystemRequired', 'ApplicationRequired', 'Recommended')]
        [string]$RequiredLevel = 'None',

        [switch]$AsHashtable,

        [Parameter(Mandatory = $false)]
        [Alias('Prefix')]
        [string]$SolutionPrefix
    )

    $TypeName = 'Money'
    $Ret = Get-BasicAttributeDefintion -TypeName $TypeName -LogicalName $LogicalName -SchemaName $SchemaName
    # type specific properties
    $Ret.MinValue = $MinValue
    $Ret.MaxValue = $MaxValue
    # type specific properties - end
    Add-DisplayName $Ret $DisplayName
    Add-Description $Ret $Description
    Add-RequiredLevel $Ret $RequiredLevel
    
    $AsHashtable.IsPresent ?  $Ret : ($Ret | ConvertTo-Json -Depth 99) 
}

