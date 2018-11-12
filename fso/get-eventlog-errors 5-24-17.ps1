$PSEmailServer = "pls-mail01.blackhawk-net.com"
Get-Eventlog -log application -after ((get-date).addDays(-1)) | Where-Object {$_.EventID -eq 10006} | export-csv "C:\scripts\sysevents.csv"
#Send-MailMessage -To "leigh.houck@bhnetwork.com" -From "udb411@bhnetwork.com" -Subject "System Events" -Attachments "c:\scripts\sysevents.csv" # -SmtpServer "pls-mail01.blackhawk-net.com"
#   Get-EventLog "Windows PowerShell" | Where-Object {$_.EventID -eq 403} 