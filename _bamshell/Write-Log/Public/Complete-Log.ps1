function Complete-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Use Initialize-Log to create LogFile.")]
        [ValidateScript( {Test-Path -LiteralPath $_})]
        [System.IO.FileInfo]$FilePath,

        [System.IO.DirectoryInfo]$ArchivesPath,

        [int]$MaxFileSize = 5MB,

        [int]$MaxRotation = 10,

        [timespan]$MaxFileAge = (New-TimeSpan -Days 7)
    )
    
    begin {        
        if ([System.Threading.Mutex]::TryOpenExisting("LogMutex", [ref]$null)) {
            $Mutex = [System.Threading.Mutex]::OpenExisting("LogMutex")
            [void]$Mutex.WaitOne()
            $Mutex.Close()
            $Mutex.Dispose()
        }     
    }
    
    process {
        $CurrentLog = Get-Item -LiteralPath $FilePath
        if (-not ($ArchivesPath)) {
            $ArchivesPath = $CurrentLog.Directory
        }
        else {
            if (-not (Test-Path -LiteralPath $ArchivesPath)) {
                New-Item -Path $ArchivesPath -ItemType Directory -Force
            }
        }
        $IsTooBig = ($CurrentLog.Length -ge $MaxFileSize)
        $IsTooOld = ((New-TimeSpan -Start ($CurrentLog.CreationTime) -End (Get-Date)) -ge $MaxFileAge)

        if ($IsTooBig -or $IsTooOld) {
            Move-Item -LiteralPath $CurrentLog.FullName -Destination $ArchivesPath -PassThru |
                Rename-Item -NewName "$(Get-Date -Format "yyyyMMddTHHmmss")_$($CurrentLog.Name)"           
        }
        
        $ExistingLogFiles = Get-ChildItem -LiteralPath $ArchivesPath | Where-Object Name -Match ([regex]::escape($CurrentLog.BaseName.ToString())) |Where-Object Name -ne $CurrentLog.Name
        if ($ExistingLogFiles.Count -gt $MaxRotation) {
            $ExistingLogFiles | Sort-Object Name | Select-Object -First 1 | Remove-Item -Force
            # $ExistingLogFiles | Sort-Object CreationTime | Select-Object -First 1 | Remove-Item -Force
        }
    }
    
    end {
    }
}