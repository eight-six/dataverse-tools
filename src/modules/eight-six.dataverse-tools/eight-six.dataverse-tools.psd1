#
# Module manifest for module 'eightsix.dataverse-tools'
#
# Generated by: StevenRose
#
# Generated on: 07/01/2024
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = './eight-six.dataverse-tools.psm1'

    # Version number of this module.
    ModuleVersion        = '99.99.99'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID                 = '204142b0-46ca-4247-9eb7-851d18a04615'

    # Author of this module
    Author               = 'Steven Rose (@stvnrs)'

    # Company or vendor of this module
    CompanyName          = 'Steven Rose'

    # Copyright statement for this module
    Copyright            = '(c) Steven Rose. All rights reserved.'

    # Description of the functionality provided by this module
    # Description = ''

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.4.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        'Az.Accounts'
    )

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules        = @(
        './nested/auth.psm1'
        './nested/environment.psm1'
        './nested/output.psm1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        #from root module
        'Get-Entity'
        'Get-EntityAttribute'
        'Get-WhoAmI'
        'Invoke-ApiRequest'
        'New-Entity'
        'Register-ArgumentCompleter'
        'Set-Entity'
        #from nested/environment.psm1
        'Add-Environment'
        'Get-Environment'
        'Remove-Environment'
        'Select-Environment'
        'Set-Environment'

        # 
        'Test-McTestFace'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @()

    # Variables to export from this module
    VariablesToExport    = ''

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    DefaultCommandPrefix = 'Dv'

}

