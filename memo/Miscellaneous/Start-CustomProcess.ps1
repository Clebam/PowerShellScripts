<#
    .SYNOPSIS
        Starts a process
    .DESCRIPTION
        Starts a process
    .PARAMETER FilePath
        Path to the executable
    .PARAMETER Arguments
        List of arguments if needed
    .PARAMETER PassThru
        Returns StandardOutput, StandardError and ExitCode
    .EXAMPLE
        $Arguments =
            "create-instance --instance Tentacle --config C:\Octopus\Tentacle.config --console",
            "new-certificate --instance Tentacle --if-blank --console",
            "configure --instance Tentacle --reset-trust --console"

        foreach ($args in $Arguments) {
            Start-CustomProcess -FilePath "$env:ProgramFiles\Octopus Deploy\Tentacle\Tentacle.exe" -Arguments $args
        }
    .EXAMPLE
        $Exec = Start-CustomProcess -FilePath "$env:ProgramFiles\Octopus Deploy\Tentacle\Tentacle.exe" -Arguments "show-thumbprint" -PassThru

        if ($Exec.ExitCode -ne 0) {
            Write-Error $Exec.StandardError
        }
        else {
            Write-Host $Exec.StandardOutput
        }

    .NOTES
        Author: Clément LE ROUX
        Version: 1.0
#>
function Start-CustomProcess {
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$FilePath,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Arguments,
        [switch] $PassThru
    )
    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $ProcessInfo.CreateNoWindow = $false
    $ProcessInfo.WindowStyle = New-Object System.Diagnostics.ProcessWindowStyle
    $ProcessInfo.WindowStyle = "Hidden"
    $ProcessInfo.FileName = $FilePath
    $ProcessInfo.RedirectStandardError = $true
    $ProcessInfo.RedirectStandardOutput = $true
    $ProcessInfo.UseShellExecute = $false
    $ProcessInfo.Arguments = $Arguments
    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $ProcessInfo
    $Process.Start() | Out-Null
    $Process.WaitForExit()

    if ($PassThru) {
        [pscustomobject]@{
            StandardOutput = $Process.StandardOutput.ReadToEnd()
            StandardError  = $Process.StandardError.ReadToEnd()
            ExitCode       = $Process.ExitCode
        }
    }
}