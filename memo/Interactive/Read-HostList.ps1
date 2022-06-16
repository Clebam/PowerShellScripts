<#
    .SYNOPSIS
        Prompts with a list of choice
    .DESCRIPTION
        Prompts with a list of choice, returns objects or index
    .PARAMETER InputObject
        Specify the list (Accepts objects)
    .PARAMETER DefaultValue
        Suggests a defaut value
    .PARAMETER ReturnIndex
        Specify if the function should return index rather than string. (index starts at 0. (so choice 1 = 0))
    .EXAMPLE
        Write-Host "Choose a day of week"
        "Monday","Tuesday","Wednesday" | Read-HostList
    .EXAMPLE
        Write-Host "Choose a day of week"
        "Monday","Tuesday","Wednesday" | Read-HostList -DefaultValue "Monday"
    .EXAMPLE
        $users = "Pierre", "Paul", "Jacques" | Get-ADUser
        $users.Item((Read-HostList -InputObject $users.name -ReturnIndex))
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Read-HostList {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$InputObject,
        [string]$DefaultValue,
        [switch]$ReturnIndex
    )

    Begin {
        $StringBuilder = New-Object System.Text.StringBuilder
        $ObjectArray = @()
        $Counter = 0
    }

    Process {
        $InputObject | ForEach-Object {
            $Counter ++
            [void]$StringBuilder.AppendLine("[$Counter]   $_")
        }
        $ObjectArray += $InputObject
    }

    End {
        [void]$StringBuilder.Append("Choose a line number ")
        if ($DefaultValue) {
            $DefaultIndex = $($ObjectArray.Indexof($DefaultValue))
            [void]$StringBuilder.Append("or press ENTER for default value [$($DefaultIndex + 1). $($ObjectArray[$DefaultIndex])]")
        }
        $Prompt = $StringBuilder.ToString()
        [void]$StringBuilder.Clear()
        do {
            $InputChoix = Read-Host -Prompt $Prompt
            $Choix = ($($DefaultIndex + 1),$InputChoix)[[bool]$InputChoix]
        }
        until ($Choix -in (1..$($Counter)))
        If ($ReturnIndex) {
            $Choix - 1
        }
        Else {
            $ObjectArray[$Choix - 1]
        }
    }
}
