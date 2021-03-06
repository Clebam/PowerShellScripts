﻿function Initialize-Log {
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]$FilePath,

        [switch]$Clear,

        [switch]$IncludeHeader,

        [switch]$Passthru,
        
        [ValidateSet("FilePath", "UseMutex", "All")]
        [string]$ForceGlobalLogCmdletParameter,

        [switch]$ForceGlobalLogCmdletPassthru,          

        [switch]$UseMutex
    )
    if ($UseMutex) {
        if ( -not ([System.Threading.Mutex]::TryOpenExisting("LogMutex", [ref]$null))) {
            $Mutex = New-Object System.Threading.Mutex($false, "LogMutex")
            [void]$Mutex.WaitOne()
            [void]$Mutex.ReleaseMutex()
        }    
    }

    if (-not(Test-Path -LiteralPath $FilePath)) {
        $null = New-Item -Path $FilePath -Force
    }

    if ($Clear) {
        $null | Out-File -LiteralPath $FilePath -Force -Encoding utf8        
    }

    if ($IncludeHeader) {
        $Now = [System.DateTime]::Now
        $FormattedDate = $Now.ToString('s')
        $FullDate = $Now.ToString('F')

        [string[]]$Header = @(
            "{0}`t{1}`t{2}" -f $FormattedDate, "Info", "Running script : $($MyInvocation.ScriptName)"                    
            "{0}`t{1}`t{2}" -f $FormattedDate, "Info", "Start time : $FullDate"  
            "{0}`t{1}`t{2}" -f $FormattedDate, "Info", "Executing account : $([Security.Principal.WindowsIdentity]::GetCurrent().Name)"
            "{0}`t{1}`t{2}" -f $FormattedDate, "Info", "ComputerName : $env:COMPUTERNAME"            
        )

        $Header | Out-File -LiteralPath $FilePath -Append -Encoding utf8
    }       

    if ($Passthru) {
        Write-Output $FilePath.FullName
    }
            
    switch ($ForceGlobalLogCmdletParameter) {
            
        {$true} {
            Write-Verbose -Message "You forced DefaultParameter of bound *-Log function. These are global scope variables. Use with caution!" 
        }
        "FilePath" {
            $global:PSDefaultParameterValues['Write-Log:FilePath'] = $FilePath.FullName
            $global:PSDefaultParameterValues['Send-Log:FilePath'] = $FilePath.FullName
            $global:PSDefaultParameterValues['Complete-Log:FilePath'] = $FilePath.FullName
            break
        }
        "Mutex" {
            $global:PSDefaultParameterValues['Write-Log:UseMutex'] = $true
            break
                
        }
        "All" {
            $global:PSDefaultParameterValues['Write-Log:UseMutex'] = $true
            $global:PSDefaultParameterValues['Write-Log:FilePath'] = $FilePath.FullName
            $global:PSDefaultParameterValues['Send-Log:FilePath'] = $FilePath.FullName
            $global:PSDefaultParameterValues['Complete-Log:FilePath'] = $FilePath.FullName
            break
        }            
        Default {break}
    }

    if ($ForceGlobalLogCmdletPassthru) {
        $global:PSDefaultParameterValues['Write-Log:Passthru'] = $true  
        $global:PSDefaultParameterValues['Write-Log:InformationAction'] = "Continue"
        $global:PSDefaultParameterValues['Write-Log:WarningAction'] = "Continue"
        $global:PSDefaultParameterValues['Write-Log:ErrorAction'] = "Continue"
    }
}  
