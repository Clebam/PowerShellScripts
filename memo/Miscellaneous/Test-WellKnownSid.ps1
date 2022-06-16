<#
    .SYNOPSIS
        Tests if an SID is a well-known SID.
    .DESCRIPTION
        Tests if an SID is a well-known SID.
    .PARAMETER SID
        Security identifier to test.
    .PARAMETER Extended
        Test if SID matches a list of common SIDs that are not well-known.
        Based on : https://renenyffenegger.ch/notes/Windows/security/SID/index
    .EXAMPLE
        Test-WellKnownSid -SID "S-1-5-21-55-55-55-500" -Extended
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Test-WellKnownSid {
    param(
        [System.Security.Principal.SecurityIdentifier]$SID,
        [switch]$Extended
    )
    $ExtendedSIDs = @(
        "S-1-5-80-", # Services
        "S-1-5-82-", # ApplicationPool Identities
        "S-1-5-94-", # Windows Remoting Virtual Users
        "S-1-15-3-", # Capability SIDs
        "S-1-16-" # Integrity Level
        )

    foreach ($wksid in [System.Security.Principal.WellKnownSidType].GetEnumNames()) {
        if ($SID.IsWellKnown([System.Security.Principal.WellKnownSidType]::$wksid)) { return $true }
    }
    if ($Extended) {
        foreach ($extsid in $ExtendedSIDs) {
            if ($SID.Value -match $extsid) { return $true }
        }
    }
    return $false
}
