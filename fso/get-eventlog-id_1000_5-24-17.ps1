$PSEmailServer = "pls-mail01.blackhawk-net.com"
Get-Eventlog -log application -after ((get-date).addDays(-1)) | Where-Object {$_.EventID -eq 1000} | export-csv "C:\symbols\sysevents.csv"