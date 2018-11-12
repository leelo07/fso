# USPSLHOUCKLW1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest  -Uri https://github.com/adbertram/MySQL/archive/master.zip -OutFile  'C:\tmp\MySQL.zip'
$modulesFolder =  'C:\Program Files\WindowsPowerShell\Modules'
Expand-Archive -Path  C:\tmp\MySql.zip -DestinationPath $modulesFolder
Rename-Item -Path  "$modulesFolder\MySql-master" -NewName MySQL
$dbCred =  Get-Credential
Connect-MySqlServer  -Credential $dbcred -Database classfiles
Invoke-MySqlQuery  -Query 'SELECT * FROM account'
$database='digitalpassmgmt'
$UserName='lhouc00'
#$Password=
#$DataSource='10.1.140.26'
$DataSource='rds-digitalpass-pp.cbh9kh9bdzqf.us-west-1.rds.amazonaws.com'
$ConnectionString = “Server=$DataSource;uid=$UserName; pwd=$Password;Database=$database;Integrated Security=False;SslMode=none”
$MySQLConnection = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$MySQLConnection.ConnectionString = $ConnectionString
$MySQLConnection.Open()
Invoke-MySqlQuery  -Query 'SELECT * FROM digitalpass'