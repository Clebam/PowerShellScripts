function Test-IPv4MaskString {
    <#
    .SYNOPSIS
    Tests whether an IPv4 network mask string (e.g., "255.255.255.0") is valid.

    .DESCRIPTION
    Tests whether an IPv4 network mask string (e.g., "255.255.255.0") is valid.

    .PARAMETER MaskString
    Specifies the IPv4 network mask string (e.g., "255.255.255.0").

    .NOTES
        Source : https://www.itprotoday.com/powershell/working-ipv4-addresses-powershell
    #>
    param(
        [parameter(Mandatory = $true)]
        [String] $MaskString
    )
    $validBytes = '0|128|192|224|240|248|252|254|255'
    $maskPattern = ('^((({0})\.0\.0\.0)|' -f $validBytes) +
    ('(255\.({0})\.0\.0)|' -f $validBytes) +
    ('(255\.255\.({0})\.0)|' -f $validBytes) +
    ('(255\.255\.255\.({0})))$' -f $validBytes)
    $MaskString -match $maskPattern
}
function ConvertTo-IPv4MaskBits {
    <#
    .SYNOPSIS
    Returns the number of bits (0-32) in a network mask string (e.g., "255.255.255.0").

    .DESCRIPTION
    Returns the number of bits (0-32) in a network mask string (e.g., "255.255.255.0").

    .PARAMETER MaskString
    Specifies the IPv4 network mask string (e.g., "255.255.255.0").

    .NOTES
        Source : https://www.itprotoday.com/powershell/working-ipv4-addresses-powershell
    #>
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript( { Test-IPv4MaskString $_ })]
        [String] $MaskString
    )
    $mask = ([IPAddress] $MaskString).Address
    for ( $bitCount = 0; $mask -ne 0; $bitCount++ ) {
        $mask = $mask -band ($mask - 1)
    }
    $bitCount
}
