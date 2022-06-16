function Test-Credential {

    [CmdletBinding()]
    [OutputType([String])]

    Param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeLine = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias(
            'PSCredential'
        )]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )
    $Domain = $null
    $Root = $null
    $Username = $null
    $Password = $null

    if($Credential -eq $null)
    {
        Try
        {
            $Credential = Get-Credential "domain\$env:username" -ErrorAction Stop
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Warning "Failed to validate Credential: $ErrorMsg "
            Pause
            Break
        }
    }

    # Checking module
    Try
    {
        # Split username and password
        $Username = $Credential.username
        $Password = $Credential.GetNetworkCredential().password

        # Get Domain
        $Root = "LDAP://" + ([ADSI]'').distinguishedName
        $Domain = New-Object System.DirectoryServices.DirectoryEntry($Root,$UserName,$Password)
    }
    Catch
    {
        $_.Exception.Message
        Continue
    }

    if(!$domain)
    {
        Write-Warning "Something went wrong"
    }
    else
    {
        if ($null -ne $domain.name)
        {
            return "Authenticated"
        }
        else
        {
            return "Not authenticated"
        }
    }
}
