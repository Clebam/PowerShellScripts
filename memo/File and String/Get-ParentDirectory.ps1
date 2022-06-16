<#
    .SYNOPSIS
        Get the parent directory of a file/directory
    .DESCRIPTION
        Get the parent directory of a file/directory (returns a string)
    .PARAMETER Path
        Path to the file/directory
    .PARAMETER Recurse
        Returns a string array of all the parent directories path
    .EXAMPLE
        Get-ParentDirectory C:\Windows\System32\drivers\etc

        C:\Windows\System32\drivers
    .EXAMPLE
        Get-ParentDirectory C:\Windows\System32\drivers\etc -Recurse

        C:\Windows\System32\drivers
        C:\Windows\System32
        C:\Windows
        C:\
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Get-ParentDirectory {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [switch]$Recurse
    )
    Do {
        $Path = Split-Path -Path $Path -Parent
        $Path
    }
    While ($Path -and $Recurse)
}