<#
    .SYNOPSIS
        Invokes Zabbix API
    .DESCRIPTION
        Invokes Zabbix API
    .PARAMETER Method
        Zabbix API method - Please refer to : https://www.zabbix.com/documentation/current/en/manual/api/reference
    .PARAMETER Params
        Zabbix API params - Please refer to each method : https://www.zabbix.com/documentation/current/en/manual/api/reference
    .PARAMETER Session
        Zabbix auth session - Use Connect-ZabbixApi
        Default : Calls Connect-ZabbixApi
    .PARAMETER Id
        Zabbix auth id
        Default : New Guid generated
    .PARAMETER ZabbixUrl
        Zabbix API endpoint
    .EXAMPLE
        $Params = @{
            search = @{
                "host"=@("srv*")
            }
            searchWildcardsEnabled = $true
            searchByAny = $true
            output = @(
                "hostid",
                "host"
            )
        }

        Invoke-ZabbixApi -Method "host.get" -Params $Params
    .NOTES
        Author : Clément Le Roux
        Version : 1.0
#>
function Invoke-ZabbixApi {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        $Method,
        [Parameter(Mandatory)]
        $Params,
        [alias("auth")]
        $Session,
        $Id = [guid]::NewGuid(),
        $ZabbixUrl = 'https://zabbix.mycompany.com/api_jsonrpc.php'
    )

    if (-not $Session) {
        $Session = Connect-ZabbixApi -Id $Id -ZabbixUrl $ZabbixUrl
    }
    $Body = @{
        jsonrpc = '2.0'
        method = $Method
        params = $Params
        id = $Id
        auth = $Session
    } | ConvertTo-Json -Depth 100

    (Invoke-RestMethod -Method Post -Uri $ZabbixUrl -ContentType 'application/json' -Body $Body).Result
}
