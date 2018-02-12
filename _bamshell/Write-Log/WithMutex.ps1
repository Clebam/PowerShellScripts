Import-module C:\Workspace\GitHub\PowerShellScripts\_bamshell\Write-Log\Bamshell.Logging.psm1 -Force
Initialize-Log -FilePath "C:\Temp\ParallelJobs.log" -IncludeHeader -Clear -UseMutex

# This is the script block that will be called each time.
$ScriptBlock = {
    param (
        $Path
    )
    # I have to import the module containing my Write-Log functions because it's session wide loaded, and jobs are in another session.
    Import-module C:\Workspace\GitHub\PowerShellScripts\_bamshell\Write-Log\Bamshell.Logging.psm1 -Force
    $ChildItem = Get-Childitem -Path $Path
    $ChildItem.FullName | Write-Log -FilePath "C:\Temp\ParallelJobs.log" -UseMutex
}

# I run parallel jobs on each Directory in C:\ and get there content.
(Get-ChildItem 'C:\Program Files' -Directory).FullName | ForEach-Object {
    Start-Job -ScriptBlock $ScriptBlock -ArgumentList $_
}

# Job function are really well made for pipelining :)
Get-job | Wait-Job | Receive-Job

