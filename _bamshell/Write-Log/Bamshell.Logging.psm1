. $PSScriptRoot\Initialize-Log.ps1
. $PSScriptRoot\Write-Log.ps1
. $PSScriptRoot\Complete-Log.ps1
. $PSScriptRoot\Send-Log.ps1
<# TODO
    # Follow good practice
        Always keep date in your log file name
        Always add some name to your log file name. It will help you in the future to distinguish log files from different instances of your system.
        Always log time and date (preferably up to milliseconds resolution) for every log event.
        Always store your date as YYYYMMDD. Everywhere. In filename, inside of logfile. It greatly helps with sorting. Some separators are allowed (eg. 2009-11-29).
        In general avoid storing logs in database. In is another point of failure in your logging schema.
        If you have multithreaded system always log thread id.
        If you have multi process system always log process id.
        If you have many computers always log computer id.
        Make sure you can process logs later. Just try importing one log file into database or Excel. If it takes longer than 30 seconds it means your logging is wrong. This includes:
        Choosing good internal format of logging. I prefer space delimeted since it works nice with  Unix text tools and with Excel.
        Choosing good format for date/time so you can easily import into some SQL databse or Excel for further proccesing.

    # Write-Log
        [x] Use better datetime
        [x] Use Add-Content | In the end, Out-File allows me to keep opened my log file.
        [x] Use LiteralPath (if necessary due to System.IO.FileInfo) In fact, it is necessary Script[].log for instance
        [x] Use [void] or $null = instead of | Out-Null
        [x] Use recommended log style
        
    # https://www.loggly.com/blog/30-best-practices-logging-scale/

    # Initialize-Log
        [x] Use LiteralPath (if necessary due to System.IO.FileInfo)
        [x] Use [void] or $null = instead of | Out-Null

    # Create Backup-Log
    # Create Send-Log   
#>