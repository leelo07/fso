[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest  -Uri https://github.com/adbertram/MySQL/archive/master.zip -OutFile  'C:\tmp\MySQL.zip'
$modulesFolder =  'C:\Program Files\WindowsPowerShell\Modules'
Expand-Archive -Path  C:\tmp\MySql.zip -DestinationPath $modulesFolder