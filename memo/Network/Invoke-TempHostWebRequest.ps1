function Invoke-TempHostWebRequest {
    <#
    .SYNOPSIS
        Temporary adds an ip/fqdn to local host file in order to perform a webrequest
    .DESCRIPTION
        Temporary adds an ip/fqdn to local host file in order to perform a webrequest
        Then it sets the hosts file back to its original content
    .PARAMETER IpAddress
        Public address of the remote host
    .PARAMETER Fqdn
        FQDN of the remote host
    .PARAMETER Protocol
        Protocol to query (http, https or ftp)
    .PARAMETER Port
        TCP Port to query
    .EXAMPLE
         Invoke-TempHostWebRequest -IpAddress "10.10.10.10" -Fqdn "contoso.com" -Protocol "https"
    .EXAMPLE
         Invoke-TempHostWebRequest -IpAddress "10.10.10.10" -Fqdn "ag1.fw.ipsos.com" -Protocol "https" -Port "9443"
    .NOTES
        Author : Clément LE ROUX
    #>
    Param(
        [Parameter(Mandatory)]
        [ipaddress]$IpAddress,
        [Parameter(Mandatory)]
        [string]$Fqdn,
        [Parameter(Mandatory)]
        [ValidateSet("http", "https", "ftp")]
        [string]$Protocol,
        [string]$Port
    )


    # Requires admin rights
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        throw "Function needs to be run elevated."
    }

    $HostsFile = "$env:windir\System32\Drivers\etc\hosts"

    if (-not (Test-Path $HostsFile)) {
        New-Item -Path $HostsFile -ItemType File
    }

    $HostsFileContent = Get-Content -Path $HostsFile -Raw

    try {
        Write-Verbose -Verbose "Temporarily adding $IpAddress`t$FQDN to $HostsFile"
        Add-Content -Path $HostsFile -Value "$IpAddress`t$FQDN" -Force
    }
    catch {
        "$_"
    }

    try {
        $Uri = "$Protocol`://$FQDN"
        if ($Port) {
            $Uri += ":$Port"
        }
        if ($Protocol -eq "ftp") {
            $Uri += "/not_a_file.txt"
        }
        Write-Verbose -Verbose "Sending webrequest to $Uri"
        Invoke-WebRequest -Uri $Uri
    }
    catch {
        "$_"
        # Because it catches all http errors, some might be a good result though :)
    }

    Write-Verbose -Verbose "Setting hostfile back to original content"
    try {
        Set-Content -Path $HostsFile -Value $HostsFileContent -Force
    }
    catch {
        "$_"
    }
}
