$name='PSCLBOSQLP01W'
$inst='10.1.244.139\ERP1'
#Invoke-Command {Get-Process} -ComputerName $name -Credential bhnetwork\lhouc00
sql -Query "select db_name()" -ServerInstance $inst -Credential bhnetwork\lhouc00
