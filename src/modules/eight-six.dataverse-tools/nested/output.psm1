$ErrorActionPreference = 'Stop'

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

    $Hashtable.Keys | % {
        if ($_ -in $SensitiveKeys) {
            $Copy.Add($_, '*******')
        }
        else {
            $Copy.Add($_, $Hashtable[$_])
        }
    }
    
    $Ret = $Copy | ConvertTo-Json -Compress

    $Ret
}
