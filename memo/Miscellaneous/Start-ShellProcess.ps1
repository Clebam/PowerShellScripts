<#
    .SYNOPSIS
        Starts a shell process
    .DESCRIPTION
        Starts a shell process. Better to use with script files rather than exe.
    .PARAMETER FilePath
        Path to the executable
    .PARAMETER Arguments
        List of arguments if needed
    .EXAMPLE
    $Arguments =
        "config set --section main vardir C:\ProgramData\PuppetLabs\puppet4\var",
        "config set --section main ssldir C:\ProgramData\PuppetLabs\puppet4\etc\ssl",
        "config set --section main logdir `$vardir/log",
        "config set --section main rundir `$vardir/run"

    foreach ($args in $Arguments) {
        Start-ShellProcess -FilePath "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" -Arguments $args
    }

    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Start-ShellProcess {
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$FilePath,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Arguments
    )
    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $ProcessInfo.CreateNoWindow = $false
    $ProcessInfo.WindowStyle = New-Object System.Diagnostics.ProcessWindowStyle
    $ProcessInfo.WindowStyle = "Hidden"
    $ProcessInfo.FileName = $FilePath
    $ProcessInfo.RedirectStandardError = $false
    $ProcessInfo.RedirectStandardOutput = $false
    $ProcessInfo.UseShellExecute = $true
    $ProcessInfo.Arguments = $Arguments
    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $ProcessInfo
    $Process.Start() | Out-Null
    $Process.WaitForExit()
}