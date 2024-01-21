
$Script:AccessToken = $null

function Get-AuthToken {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ResourceUrl,

        [switch]$ForceRefresh,

        [switch]$NoCache
    )

    $AccessToken = $null

    if ($ForceRefresh.IsPresent -or $null -eq $Script:AccessToken -or $Script:AccessToken.ExpiresOn -lt (Get-Date)) {
        Write-Verbose "Getting new access token for $ResourceUrl" -Verbose
        $AccessToken = Get-AzAccessToken -ResourceUrl $ResourceUrl
        $Script:AccessToken = $NoCache.IsPresent ? $null : $AccessToken
    }
    else {
        Write-Verbose "Using cached access token for $ResourceUrl" -Verbose
        $AccessToken = $Script:AccessToken
    }

    $AccessToken.Token
}


