
function Test-IPInSubnet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [IPAddress] $Subnet,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [IPAddress] $SubnetMask,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [IPAddress] $IPAddress
    )

    $Subnet.Address -eq ($IPAddress.Address -band $SubnetMask.Address)
}
