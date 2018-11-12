# PowerShell cmdlet to stop the Perf log and alert service
$srvName = "MSSQLSERVER"
$servicePrior = Get-Service $srvName
"$srvName is now " + $servicePrior.status
Stop-Service $srvName -force 
$serviceAfter = Get-Service $srvName
 Set-Service $srvName -startuptype disabled
"$srvName is now " + $serviceAfter.status
