$Script:ConfigFolder = '~/.dataverse-tools'
$Script:CurrentEnvironment = $null

function Get-EnvironmentFilePath {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$FriendlyName
    )

    Join-Path $Script:ConfigFolder "$FriendlyName.environment.xml"
}

function Add-Environment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ $_ -match 'https://[a-z0-9]+.api.crm[0-9]{0,2}.dynamics.com' })]
        [string]$Uri,
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$FriendlyName
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (Test-Path $FilePath) {
        throw "Environment with friendly name '$FriendlyName' already exists. Use Set-Environment to update it."
    }

    $Environment = [PSCustomObject]@{
        FriendlyName = $FriendlyName
        Uri          = $Uri
        Solution     = $Solution
    }

    if (!(Test-Path $Script:ConfigFolder -PathType 'Container' -ErrorAction 'SilentlyContinue')) {
        New-Item -Path $Script:ConfigFolder -ItemType 'Directory' -Force | Out-Null
    }

    $Environment | Export-Clixml -Path $FilePath

}

function Set-Environment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$FriendlyName,
        [Parameter(Mandatory, Position = 1)]
        [ValidateScript({ $_ -match 'https://[a-z0-9]+.api.crm[0-9]{0,2}.dynamics.com' })]
        [string]$Uri,
        [Parameter(Mandatory = $false)]
        [string]$Solution
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    $Environment = [PSCustomObject]@{
        FriendlyName = $FriendlyName
        Uri          = $Uri
        Solution     = $Solution
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

function Select-Environment {
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$FriendlyName
    )

    $FilePath = Get-EnvironmentFilePath -FriendlyName $FriendlyName

    if (!(Test-Path $FilePath)) {
        throw "Environment with friendly name '$FriendlyName' does not exist. Use Add-Enironment or Set-Environment to create it."
    }

    $Script:CurrentEnvironment = Import-Clixml -Path $FilePath

}

