<#
    .SYNOPSIS
        Returns empty organizational units ou paths
    .DESCRIPTION
        Returns empty organizational units ou paths
        OUs are considered empty if they contain only empty OUs.
    .PARAMETER SearchBase
        OU Path
    .PARAMETER All
        Specify to return all the empty sub-ous.
        Default : Returns only highest parent of an empty OU branch.
    .EXAMPLE
        Get-EmptyADOrganizationalUnit -SearchBase "OU=WestCompany,DC=contoso,DC=com"
    .EXAMPLE
        Get-EmptyADOrganizationalUnit -SearchBase "OU=WestCompany,DC=contoso,DC=com" -All
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Get-EmptyADOrganizationalUnit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $SearchBase,
        [switch] $All
    )
    process {
        if (-not(Get-ADObject -SearchBase $SearchBase -SearchScope Subtree -Filter * -Properties objectclass | Where-Object objectclass -ne "organizationalunit")) {
            $SearchBase
            if ($All) {
                Get-ADOrganizationalUnit -SearchBase $SearchBase -SearchScope Subtree -Filter * | Select-Object -ExpandProperty DistinguishedName | Where-Object { $_ -ne $SearchBase }
            }
        }
        else {
            foreach ($oupath in $(Get-ADOrganizationalUnit -SearchBase $SearchBase -SearchScope OneLevel -Filter * | Select-Object -ExpandProperty DistinguishedName)) {
                Get-EmptyADOrganizationalUnit -OUPath $oupath -All:$All
            }
        }
    }
}
