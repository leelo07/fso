$server = "LWBHN00002028"
$s = Get-WmiObject -Class Win32_SystemServices -ComputerName $server
if ($s | select PartComponent | where {$_ -like "*ClusSvc*"}) { Write-Output "$server is Clustered" }
else { Write-Output "$server is Not clustered" }