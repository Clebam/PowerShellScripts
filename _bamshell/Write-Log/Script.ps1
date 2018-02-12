Import-Module C:\Workspace\GitHub\PowerShellScripts\_bamshell\Write-Log\Bamshell.Logging.psm1 -Force

Initialize-Log -FilePath C:\Temp\Script[].log -Clear -IncludeHeader -ForceGlobalLogCmdletParameter All -ForceGlobalLogCmdletPassthru -UseMutex

Write-Log "Ok"
Write-Log "An error occured" -Level Error
Write-Log "Something is not really correct." -Level Warning

Send-Log

Complete-Log