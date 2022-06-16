<#
    .SYNOPSIS
        Converts string with accuented characters to their non-accuented equivalent
    .DESCRIPTION
        Converts string with accuented characters to their non-accuented equivalent
    .PARAMETER String
        String to convert
    .EXAMPLE
        Convert-StringLatinCharacters "Eléonore vit à Liège."

        Eleonore vit a Liege.
    .NOTES
        Author : Marcin Krzanowicz
        Version : 1.0
        Source : https://lazywinadmin.com/2015/05/powershell-remove-diacritics-accents.html
#>
function Convert-StringLatinCharacters {
    param (
        [parameter(ValueFromPipeline = $true)]
        [string]$String
    )
    process {
        [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
    }
}
