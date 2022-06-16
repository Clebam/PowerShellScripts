<#
    .SYNOPSIS
        Returns all the groups that an ADPrincipal is member of. Recursively.
    .DESCRIPTION
        Returns all the groups that an ADPrincipal is member of. Recursively.
    .PARAMETER Identity
        ADPrincipal Identity
        Accepts : [ADPrincipal], SamAccountName, Name, DistinguishedName, UserPrincipalName, SID
    .EXAMPLE
        Get-ADUser bob | Get-ADPrincipalGroupMembershipRecursive
    .EXAMPLE
        Get-ADPrincipalGroupMembershipRecursive -Identity "CN=Alice Smith,OU=Users,OU=Staff,DC=contoso,DC=org"
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>

function Get-ADPrincipalGroupMembershipRecursive {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $Identity
    )
    if ($Identity -isnot [string]) {
        $ADObject = Get-ADObject -Identity $Identity
    }
    else {
        $ADObject = Get-ADObject -Filter "SamAccountName -eq '$Identity' -or Name -eq '$Identity' -or DistinguishedName -eq '$Identity' -or UserPrincipalName -eq '$Identity'-or ObjectSID -eq '$Identity'"
    }

    Get-ADGroup -Filter ("member -recursivematch '{0}'" -f $ADObject.DistinguishedName)
}
