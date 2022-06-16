function ConvertFrom-IPv4MaskBits {
    <#
    .SYNOPSIS
    Returns a network mask string (e.g., "255.255.255.0") from the number of bits (0-32) CIDR notation.

    .DESCRIPTION
    Returns a network mask string (e.g., "255.255.255.0") from the number of bits (0-32) CIDR notation.

    .PARAMETER Cidr
    Specifies the Cidr (0-32)
    #>
    param(
        [parameter(Mandatory = $true)]
        [ValidateRange(0, 32)]
        [String] $Cidr
    )
    ([ipaddress](4.GB - (4GB -shr $Cidr))).tostring()
}
