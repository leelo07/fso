# PowerShell cmdlet to stop SQL Server default and agent services
# then disable them
$srvName = "MSSQLSERVER"
$agentName = "SQLSERVERAGENT"
$servicePrior = Get-Service $srvName
"$srvName is now " + $servicePrior.status
Stop-Service $srvName -force 
$serviceAfter = Get-Service $srvName
Set-Service $srvName -startuptype disabled
Set-Service $agentName -startuptype disabled
"$srvName is now " + $serviceAfter.status