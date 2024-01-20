
$Script:AccessToken = $null

function Get-AuthToken{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ResourceUrl
    )

    if($null -eq $Script:AccessToken -or $Script:AccessToken.ExpiresOn -lt (Get-Date)){
        Write-Verbose "Getting new access token for $ResourceUrl" -Verbose
        $Script:AccessToken = Get-AzAccessToken -ResourceUrl $ResourceUrl
    } else {
        Write-Verbose "Using cached access token for $ResourceUrl" -Verbose
    }

    $Script:AccessToken.Token
}


