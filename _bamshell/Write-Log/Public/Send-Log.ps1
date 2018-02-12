function Send-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Use Initialize-Log to create LogFile.", ValueFromPipeline, Position = 0)]
        [ValidateScript( {Test-Path -LiteralPath $_})]
        [System.IO.FileInfo]$FilePath,

        [ValidateSet("Info", "Warning", "Error")]
        [string]$MinLevel = "Error"
    )
    
    begin {
        # SMTP and Mail configuration
        # SMTP
        $UserName = "User"
        $PassWord = "Pass"
        $SmtpServer = "smtp.example.com"
        $SmtpClient = New-Object Net.Mail.SmtpClient($SmtpServer) 
        $SmtpClient.Port = 587
        $SmtpClient.EnableSsl = $true
        $SmtpClient.Credentials = New-Object System.Net.NetworkCredential($UserName, $PassWord)
        # Mail
        $MailMessage = New-Object Net.Mail.MailMessage
        $MailMessage.From = "syadmin@bamshell.bam"
        $MailMessage.To.Add("syadmin@bamshell.bam")
        $MailMessage.Body = "Please analyse attached files."
        $MailMessage.Subject = "Report : $($MyInvocation.ScriptName) - Level Triggered : $MinLevel"    
        
        switch ($MinLevel) {
            "Info" {$Level = "Info", "Warning", "Error"; break}
            "Warning" {$Level = "Warning", "Error"; break}
            "Error" {$Level = "Error"; break}
        }
    }
    
    process {
        $ImportLog = Import-Csv -LiteralPath $FilePath -Header "DateTime", "Level", "Message" -Delimiter "`t"
        if (Compare-Object -ReferenceObject $ImportLog.Level -DifferenceObject $Level -IncludeEqual -ExcludeDifferent) {
            $MailMessage.Attachments.Add($(New-Object System.Net.Mail.Attachment –ArgumentList $FilePath.FullName))
        }       
    }
    
    end {
        if ($MailMessage.Attachments) {
            $SmtpClient.Send($MailMessage)
            $MailMessage.Dispose()
            $SmtpClient.Dispose()
        }       
    }
}