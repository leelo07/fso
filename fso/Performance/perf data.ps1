$processor = (Get-Counter -listset processor).paths
 
$physicalDisk = (Get-Counter -listset physicaldisk).paths
 
$memory = (Get-Counter -listset memory).paths
 
$network = (Get-Counter -listset 'network interface').paths
 
$mycounters = $processor + $physicalDisk + $memory + $network
 
$perf = Get-Counter -Counter $mycounters -SampleInterval 3 -MaxSamples 4
 
$perf
