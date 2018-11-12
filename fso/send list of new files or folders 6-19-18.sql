Param (
	[string]$Path = "c:\watchfolder\",
	[string]$SMTPServer = "smtp.whatever.com",
	[string]$From = "watchfolder@mycompany.com",
	[string]$To = "myname@mycompany.com;somebodyelse@mycompany.com",
	[string]$Subject = "Hours Worked report for last week"
	)

$SMTPMessage = @{
    To = $To
    From = $From
	Subject = "$Subject at $Path"
    Smtpserver = $SMTPServer
}

$File = Get-ChildItem $Path | Where { ($_.LastWriteTime -ge [datetime]::Now.AddDays(-1) ) -and ( $_.BaseName -like 'Micropay View Hours Report*') }
If ($File)
{	$SMTPBody = "`nThe following files have recently been added/changed:`n`n"
	$File | ForEach { $SMTPBody += "$($_.FullName)`n" }
	Send-MailMessage @SMTPMessage -Body $SMTPBody
	
}
