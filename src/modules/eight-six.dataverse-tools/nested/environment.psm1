$Script:ConfigFolder = '~/.dataverse-tools'
$Script:CurrentEnvironment = $null

function Add-Environment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$FriendlyName,
        [Parameter(Mandatory, Position = 1)]
        [ValidatePattern('https://[a-z0-9]+.crm[0-9]{0,2}.dynamics.com')]
        [string]$Uri,
        [Parameter(Mandatory, Position = 2)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$Solution,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ApiPath = 'api/data',
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidatePattern('v[0-9]+\.[0-9]+$')]
        [string]$ApiVersion = 'v9.2',
        [Parameter(Mandatory = $false, Position = 5)]
        [ValidatePattern('[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}')]
        [string]$EnvironmentId
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (Test-Path $FilePath) {
        throw "Environment with friendly name '$FriendlyName' already exists. Use Set-Environment to update it."
    }

    $EnvironmentUri = 'https://admin.powerplatform.microsoft.com/environments/environment/{{EnvironmentId}}/hub'
    $MakeUri = "https://make.powerapps.com/environments/{{EnvironmentId}}/home"
    
    if ( $EnvironmentId.Length -gt 0) {
        $EnvironmentUri = $EnvironmentUri -replace '{{EnvironmentId}}', $EnvironmentId
        $MakeUri = "https://make.powerapps.com/environments/$EnvironmentId/home"
    }

    $ApiUri = "$($Uri -replace '\.crm', '.api.crm')/$ApiPath/$ApiVersion"
        
    $Environment = [PSCustomObject]@{
        FriendlyName        = $FriendlyName
        Uri                 = $Uri
        Solution            = $Solution
        ApiPath             = $ApiPath
        ApiVersion          = $ApiVersion
        ApiUri              = $ApiUri 
        EnvironmentId       = $EnvironmentId
        EnvironmentUri      = $EnvironmentUri 
        MakeUri             = $MakeUri  
        AdvancedSettingsUri = "$Uri/main.aspx?settingsonly=true"
    }

    if (!(Test-Path $Script:ConfigFolder -PathType 'Container' -ErrorAction 'SilentlyContinue')) {
        New-Item -Path $Script:ConfigFolder -ItemType 'Directory' -Force | Out-Null
    }

    $Environment | Export-Clixml -Path $FilePath

}

function Get-Environment {
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter({ '{{EnvironmentNameCompleter}}' })]
        [string]$FriendlyName,

        [switch]$Current
    )

    if ($Current.IsPresent) {
        $Ret = $Script:CurrentEnvironment
    }
    else {
    
        $Ret = @()
        if (!$FriendlyName) {
            Get-ChildItem -Path $Script:ConfigFolder -Filter '*.environment.xml' | ForEach-Object {
                $Ret += Import-Clixml -Path $_.FullName
            }
        }
        else {
            $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName
            $Ret += Import-Clixml -Path $FilePath
        }
    }
    $Ret
}

function Get-EnvironmentFilePath {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter( {
                param (
                    $commandName,
                    $parameterName,
                    $wordToComplete,
                    $commandAst,
                    $fakeBoundParameters 
                )

                GetEnvionmentNameCompletions @PSBoundParameters
            } 
        )]
        [string]$FriendlyName
    )

    Join-Path $Script:ConfigFolder "$FriendlyName.environment.xml"
}

function Remove-Environment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter({ '{{EnvironmentNameCompleter}}' })]
        [string]$FriendlyName
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (!(Test-Path $FilePath)) {
        throw "Environment with friendly name '$FriendlyName' does not exist."
    }

    Remove-Item -Force -Path $FilePath

}

function Set-Environment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter({ '{{EnvironmentNameCompleter}}' })]
        [string]$FriendlyName,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidatePattern('https://[a-z0-9]+.api.crm[0-9]{0,2}.dynamics.com')]
        [string]$Uri,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$Solution,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ApiPath = 'api/data',
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidatePattern('v[0-9]+\.[0-9]+$')]
        [string]$ApiVersion = 'v9.2',
        [Parameter(Mandatory = $false, Position = 5)]
        [ValidatePattern('[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}')]
        [string]$EnvironmentId
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (!(Test-Path $FilePath)) {
        Add-Environment @PSBoundParameters
    }
    else {

        $Environment = Get-Environment -FriendlyName $FriendlyName

        if ($Uri.Length -gt 0) {
            $Environment.Uri = $Uri
        }

        if ($Solution.Length -gt 0) {
            $Environment.Solution = $Solution
        }

        if ($ApiPath.Length -gt 0) {
            $Environment.ApiPath = $ApiPath
        }

        if ($ApiVersion.Length -gt 0) {
            $Environment.ApiVersion = $ApiVersion
        }

        if ($ApiPath.Length -gt 0) {
            $Environment.ApiPath = $ApiPath
        }

        if ($ApiVersion.Length -gt 0 -or $ApiPath.Length -gt 0) {
            $Environment.ApiUri = "$($Environment.Uri)/$($Environment.ApiPath)/$($Environment.ApiVersion)"
        }

        $EnvironmentIdUri = 'https://admin.powerplatform.microsoft.com/environments/environment/{{EnvironmentId}}}/hub'

        if ( $EnvironmentId.Length -gt 0) {
            $Environment.EnvironmentUri = $EnvironmentIdUri -replace '{{EnvironmentId}}', $EnvironmentId
        }

        if (!(Test-Path $Script:ConfigFolder -PathType 'Container' -ErrorAction 'SilentlyContinue')) {
            New-Item -Path $Script:ConfigFolder -ItemType 'Directory' -Force | Out-Null
        }

        $Environment | Export-Clixml -Path $FilePath
    }

}

function Select-Environment {
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [ArgumentCompleter({ '{{EnvironmentNameCompleter}}' })]
        [string]$FriendlyName
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (!(Test-Path $FilePath)) {
        throw "Environment with friendly name '$FriendlyName' does not exist. Use Add-Environment or Set-Environment to create it."
    }

    $Script:CurrentEnvironment = Import-Clixml -Path $FilePath

}
