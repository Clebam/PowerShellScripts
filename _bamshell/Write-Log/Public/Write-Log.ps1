function Write-Log {
    [CmdletBinding()]
    param
    (       
        [Parameter(Mandatory, HelpMessage = "Use Initialize-Log to create LogFile.")]
        [ValidateScript( {Test-Path -LiteralPath $_})]
        [System.IO.FileInfo]$FilePath,
       
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$Message,

        [ValidateSet("Info", "Warning", "Error")]
        $Level = "Info",

        [switch]$Passthru,

        [switch]$UseMutex
    )
    begin {
        if ($UseMutex) {
            try {
                $Mutex = New-Object System.Threading.Mutex($false, "LogMutex")
                [void]$Mutex.WaitOne()
            }
            catch [System.Threading.AbandonedMutexException] {
                # It may happen if a Mutex is not released correctly, but it will still get the Mutex.
            }
        }          
    }
    process {
        $FormattedDate = [System.DateTime]::Now.ToString('s')
        $OutString = "{0}`t{1}`t{2}" -f $FormattedDate, $Level, $Message
        $OutString | Out-File -LiteralPath $FilePath -Append -Encoding utf8
        if ($Passthru) {
            switch ($Level) {
                "Info" { Write-Information $OutString; break }
                "Warning" { Write-Warning $OutString; break }
                "Error" { Write-Error $OutString; break }
            }    
        }
    }
    end {
        if ($UseMutex) {
            [void]$Mutex.ReleaseMutex()
        }      
    }
}