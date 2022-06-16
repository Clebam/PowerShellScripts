<#
    .SYNOPSIS
        Creates a Yes-No prompt
    .DESCRIPTION
        Creates a Yes-No prompt, returns true with yes and false with no
    .PARAMETER Message
        Message to display
    .EXAMPLE
        Read-HostYesNo "Do you want to continue ?"

        Do you want to continue ?
        [Y] Yes     [N] No :
    .EXAMPLE
        if (Read-HostYesNo "Do you want to continue ?") {
            # Do something
        }
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Read-HostYesNo {

    Param(
        [Parameter(Mandatory = $True)]
        [string]$Message
    )

    Begin {
        [string[]]$ReponsesOui = "y", "o", "yes", "oui", "ok"
        [string[]]$ReponsesNon = "n", "no", "non"

        # Création d'un StringBuilder
        $StringBuilder = New-Object System.Text.StringBuilder
        [void]$StringBuilder.AppendLine()
        [void]$StringBuilder.AppendLine("$Message")
        [void]$StringBuilder.Append("[Y] Yes     [N] No ")
        # Création du prompt et suppression
        $Prompt = $StringBuilder.ToString()
        [void]$StringBuilder.Clear()
    }

    Process {
        Do {
            $Reponse = Read-Host $Prompt
            if ($Reponse) {
                $Reponse = $Reponse.ToLower()
            }
        } while ($ReponsesOui -notcontains $Reponse -and $ReponsesNon -notcontains $Reponse)
    }

    End {
        # On retourne le résultat en true ou false selon la réponse
        $Reponse -in $ReponsesOui
    }
}