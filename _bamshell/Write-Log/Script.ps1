Import-Module C:\Workspace\GitHub\PowerShellScripts\_bamshell\Write-Log\Bamshell.Logging.psm1 -Force


Initialize-Log -FilePath C:\Temp\Script[].log -Clear -IncludeHeader -ForceGlobalLogCmdletParameter All -ForceGlobalLogCmdletPassthru -UseMutex

Write-Log "Ok"
Write-Log -Level Error -Message "Not ok"
Write-Log "Strange" -Level Warning

#Send-Log

Complete-Log