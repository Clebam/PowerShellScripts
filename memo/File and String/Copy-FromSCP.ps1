<#
    .SYNOPSIS
        Copy files to a remote server
    .DESCRIPTION
        Copy files to a remote server
    .PARAMETER Server
        Name or IP of the remote server
    .PARAMETER Port
        SSH Port. Default : 22
    .PARAMETER RemotePath
        Source Path
    .PARAMETER LocalPath
        Destination Path
    .PARAMETER Username
        Username. Should be authorized to SSH on the server
    .PARAMETER SSHKey
        SSHKey use to connect to the server with the username
    .EXAMPLE
        $Splatting = @{
            Server = "10.10.10.10"
            Port = "2222"
            UserName = "ftpuser"
            SSHKey = "$PSScriptRoot\Config\id_rsa"
            RemotePath = "/data/exportad/ExportAD.zip"
            LocalPath = "$PSScriptRoot\Data"
        }
        Copy-FromSCP @Splatting
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Copy-FromSCP {
    param (
        $Server,
        $Port="22",
        $RemotePath,
        $LocalPath,
        $Username,
        $SSHKey
    )
    scp -P $Port -i $SSHKey $Username@$Server`:$RemotePath $LocalPath
}
