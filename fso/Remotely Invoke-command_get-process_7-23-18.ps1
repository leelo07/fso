# winrm s winrm/config/client '@{TrustedHosts="VSCLUTIL02W"}'
$name='VSCLUTIL02W'
Invoke-Command {Get-Process} -ComputerName $name -Credential corp\lhouc00