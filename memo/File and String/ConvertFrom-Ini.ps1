# https://stackoverflow.com/questions/417798/ini-file-parsing-in-powershell
# Need some rework
<#
    .SYNOPSIS
        Converts standard ini file to PSCustomObject
    .DESCRIPTION
        Converts standard ini file to PSCustomObjectt
    .PARAMETER FilePath
        Ini File to convert
    .EXAMPLE
        ConvertFrom-Ini -Path C:\workspace\data.ini
    .NOTES
        Author : Mehrdad Mirreza
        Version : 1.0
        Source : https://stackoverflow.com/questions/417798/ini-file-parsing-in-powershell
#>
Function ConvertFrom-Ini {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $Path
  )
  $ini = [ordered]@{}

  # Create a default section if none exist in the file. Like a java prop file.
  $section = "NO_SECTION"
  $ini[$section] = [ordered]@{}

  switch -regex -file $file {
    "^\[(.+)\]$" {
      $section = $matches[1].Trim()
      $ini[$section] = [ordered]@{}
    }

    "^\s*(.+?)\s*=\s*(.*)" {
      $name, $value = $matches[1..2]
      $ini[$section][$name] = $value.Trim()
    }

    default {
      $ini[$section]["<$("{0:d4}" -f $CommentCount++)>"] = $_
    }
  }

  [pscustomobject]$ini
}
