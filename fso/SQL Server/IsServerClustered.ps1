$server = "LWBHN00002028"
$s=Get-WMIObject -query "select * from Win32_ComputerSystem" -ComputerName $server | select name
if ($s.name -ne $server) {
 Write-Output "$server is clustered"
} else {
 Write-Output "$server is not clustered"
}