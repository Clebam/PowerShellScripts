<#
    .SYNOPSIS
        Connects Zabbix API
    .DESCRIPTION
        Connects Zabbix API
    .PARAMETER Credential
        Credential to access Zabbix API
    .PARAMETER Id
        Zabbix auth id
        Default : New Guid generated
    .PARAMETER ZabbixUrl
        Zabbix API endpoint
    .EXAMPLE
        $ZabbixSession = Connect-ZabbixApi
        Invoke-ZabbixApi -Session $ZabbixSession
    .NOTES
        Author : Clément Le Roux
        Version : 1.0
#>
function Connect-ZabbixApi {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory)]
        [Alias('PSCredential')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        $Id = [guid]::NewGuid(),
        $ZabbixUrl = 'https://zabbix.mycompany.com/api_jsonrpc.php'
    )

    $Body = @{
        jsonrpc = '2.0'
        method  = 'user.login'
        params  = @{
            user     = $Credential.GetNetworkCredential().UserName
            password = $Credential.GetNetworkCredential().Password
        }
        id      = $Id
        auth    = $null
    } | ConvertTo-Json -Depth 100

    (Invoke-RestMethod -Uri $ZabbixUrl -ContentType 'application/json' -Method Post -Body $Body).Result
}
