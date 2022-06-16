function Get-EasyList {
    <#
    .SYNOPSIS
        Generate a dynamic list of string
    .DESCRIPTION
        Generate a dynamic list of string
    .PARAMETER Prefix
        String before the wanted value
    .PARAMETER Suffix
        String after the wanted value
    .PARAMETER Value
        Array of wanted value
    .PARAMETER Padding
        Padding used when numeric values. Default to largest number padding. Ignored with non numerics.
    .EXAMPLE
        Get-EasyList -Prefix "srvweb-" -Value $(1..26) -Suffix "-iis.domain.net"
    .EXAMPLE
        Get-EasyList -Prefix "serveur-" -Value $([char[]]([int][char]'A'..[int][char]'Z'))
    .NOTES
        Author : Clément LE ROUX
    #>
    Param(
        [string]$Prefix,
        [string]$Suffix,
        $Value,
        [string]$Padding
    )
    if (-not $Padding) {
        $Padding = "0" * $Value[-1].ToString().Length
    }
    foreach ($val in $Value) {
        if ($val.GetType().Name -eq "String" -and $val -match '^\d+$') {
            "$Prefix$("{0:$Padding}" -f $([int]$val))$Suffix"
        }
        elseif ($val.GetType().Name -eq "String") {
            "$($Prefix)$($val)$($Suffix)"
        }
        else {
            "$Prefix$("{0:$Padding}" -f $val)$Suffix"
        }
    }
}
