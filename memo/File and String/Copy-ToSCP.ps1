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
        Destination Path
    .PARAMETER LocalPath
        Source Path
    .PARAMETER Username
        Username. Should be authorized to SSH on the server
    .PARAMETER SSHKey
        SSHKey use to connect to the server with the username
    .EXAMPLE
        $Splatting = @{
            Server = "10.140.128.239"
            Port = "2222"
            UserName = "ftpuser"
            SSHKey = "$PSScriptRoot\Config\id_rsa"
            RemotePath = "/data/exportad"
            LocalPath = "$PSScriptRoot\Data\ExportAD.zip"
        }
        Copy-ToSCP @Splatting
    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Copy-ToSCP {
    param (
        $Server,
        $Port="22",
        $RemotePath,
        $LocalPath,
        $Username,
        $SSHKey
    )
    scp -P $Port -i $SSHKey $LocalPath $Username@$Server`:$RemotePath
}
