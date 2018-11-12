Param (
	[string]$Path = "E:\DATA\databases\FC_S_AX2009_PP\fc\streams\",
	[string]$SMTPServer = "pls-mail01.blackhawk-net.com",
	[string]$From = "udb.411@bhnetwork.com",
	[string]$To = "leigh.houck@bhnetwork.com",
	[string]$Subject = "Hours Worked report for last week"
	)

$SMTPMessage = @{
    To = $To
    From = $From
	Subject = "$Subject at $Path"
    Smtpserver = $SMTPServer
}

$File = Get-ChildItem $Path | Where { ($_.LastWriteTime -le [datetime]::Now.AddDays(-2) ) -and ( $_.BaseName -like 'load000*') }
If ($File)
{	$SMTPBody = "`nThe following files have recently been added/changed:`n`n"
	$File | ForEach { $SMTPBody += "$($_.FullName)`n" }
	Send-MailMessage @SMTPMessage -Body $SMTPBody
	
}