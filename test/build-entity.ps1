param (
    [switch]$Create
)

$ErrorActionPreference = 'Stop'

# . "$PSScriptRoot\test-bootstrap.ps1"
. "$PSScriptRoot\..\src\modules\eight-six.dataverse-tools\nested\builder.ps1"
$SchemaNamePrefix = 'new'

$EntityParams = [ordered]@{
    LogicalName           = "$($SchemaNamePrefix)_trustee_discretion" 
    SchemaName            = "$($SchemaNamePrefix)_trustee_discretion" 
    DisplayName           = 'Trustee Discretion' 
    Description           = 'Trustee Discretion created via API'
    DisplayCollectionName = 'Trustee Discretions'
    #SchemaNamePrefix = "new" 
}

$PrimaryNameAttributeParams = [ordered]@{
    LogicalName = "$($SchemaNamePrefix)_primary_name"
    SchemaName  = "$($SchemaNamePrefix)primary_name"
    DisplayName = 'Case Number' 
    Description = 'unique case number for the trustee discretion'
    MaxLength   = 12  # TX-YYYY-NNNN
    IsPrimary   = $true
    FormatName = 'mutiline'

    #SchemaNamePrefix = "new" 
    
}

$SynopsisAttributeParams = [ordered]@{
    LogicalName = "$($SchemaNamePrefix)_synopsis"
    SchemaName  = "$($SchemaNamePrefix)_synopsis"
    DisplayName = "Synopsis"
    Description = "Synopsis..."
    MaxLength   = 50
    IsPrimary   = $false
    #SchemaNamePrefix = "cr86f" 
}

$RulesAttributeParams = [ordered]@{
    LogicalName = "$($SchemaNamePrefix)_rules"
    SchemaName  = "$($SchemaNamePrefix)_rules"
    DisplayName = "Rules"
    Description = "Rules..."
    MaxLength   = 50
    IsPrimary   = $false
    #SchemaNamePrefix = "cr86f" 
}

$GuidanceAttributeParams = [ordered]@{
    LogicalName = "$($SchemaNamePrefix)_guidance"
    SchemaName  = "$($SchemaNamePrefix)_guidance"
    DisplayName = "Guidance"
    Description = "Guidance..."
    MaxLength   = 50
    IsPrimary   = $false
    #SchemaNamePrefix = "cr86f" 
}


$Attributes = @(
    New-StringAttributeDefinition @PrimaryNameAttributeParams -AsHashtable
    New-StringAttributeDefinition @SynopsisAttributeParams -AsHashtable
    New-StringAttributeDefinition @RulesAttributeParams -AsHashtable
    New-StringAttributeDefinition @GuidanceAttributeParams -AsHashtable
    # New-BooleanAttributeDefinition @IsActiveAttributeParams -AsHashtable
)

$EntityDefinition = New-EntityDefinition @EntityParams -AttributeDefinition $Attributes
# $EntityDefinition  | scb
if ($Create.IsPresent) {
    New-DvEntity -EntityDefinition $EntityDefinition 
}
else {
    Set-DvEntity -JsonDefinition $EntityDefinition -LogicalName $EntityParams.LogicalName
}