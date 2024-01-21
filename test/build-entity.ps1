param (
    [switch]$Create
)

$ErrorActionPreference = 'Stop'

# . "$PSScriptRoot\test-bootstrap.ps1"
. "$PSScriptRoot\..\src\modules\eight-six.dataverse-tools\nested\builder.ps1"

$EntityParams = [ordered]@{
    LogicalName           = 'cr86f_lorem_ipsum' 
    SchemaName            = 'cr86f_lorem_ipsum' 
    DisplayName           = 'Lorem Ipsum' 
    Description           = 'Lorem Ipsum created via API'
    DisplayCollectionName = 'Lorem Ipsums' 
    # PrimaryIdAttribute = "cr86f_testentityid" 
    # PrimaryNameAttribute "cr86f_name" 
    #SchemaNamePrefix = "cr86f" 
}

$FamilyNameAttributeParams = [ordered]@{
    LogicalName = 'cr86f_family_name' 
    SchemaName  = 'cr86f_family_name' 
    DisplayName = 'Family Name' 
    Description = 'Family Name aka Last Name, Surname'
    MaxLength   = 50
    IsPrimary   = $false

    #SchemaNamePrefix = "cr86f" 
}

$GivenNameAttributeParams = [ordered]@{
    LogicalName = 'cr86f_given_name' 
    SchemaName  = 'cr86f_given_name' 
    DisplayName = 'Given Name' 
    Description = 'Given Name aka First Name'
    MaxLength   = 50
    IsPrimary   = $true
    #SchemaNamePrefix = "cr86f" 
}

$DateOfBirthAttributeParams = [ordered]@{
    LogicalName = 'cr86f_date_of_birth' 
    SchemaName  = 'cr86f_date_of_birth' 
    DisplayName = 'Date of birth' 
    Description = 'Date of birth'
    Format      = 'DateOnly'
    #SchemaNamePrefix = "cr86f" 
}

$CommuteAttributeParams = [ordered]@{
    LogicalName = 'cr86f_commute_distance' 
    SchemaName  = 'cr86f_commute_distance' 
    DisplayName = 'How far do you commute?' 
    Description = 'Distance in miles from home to work'
    MinValue    = 0
    MaxValue    = 500
    #SchemaNamePrefix = "cr86f" 
}

$IsActiveAttributeParams = [ordered]@{
    LogicalName = 'cr86f_is_active' 
    SchemaName  = 'cr86f_is_active' 
    DisplayName = 'Is Active?' 
    Description = 'Is the user an active employee?'
    DefaultValue = $true
    #SchemaNamePrefix = "cr86f" 
}

$Attributes = @(
    New-StringAttributeDefinition @FamilyNameAttributeParams -AsHashtable
    New-StringAttributeDefinition @GivenNameAttributeParams -AsHashtable
    New-DateTimeAttributeDefinition @DateOfBirthAttributeParams -AsHashtable
    New-IntegerAttributeDefinition @CommuteAttributeParams -AsHashtable
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