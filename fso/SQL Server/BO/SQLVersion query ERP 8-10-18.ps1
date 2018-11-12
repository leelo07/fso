﻿$Query = "declare @Nodes Varchar(100) 

set @Nodes='' 
 if (SERVERPROPERTY('IsClustered') = 1) 

begin 
select @Nodes=@Nodes+ NodeName   
+',' from sys.dm_os_cluster_nodes order by NodeName 
set @Nodes=substring(@Nodes,0,LEN(@Nodes)) 
select  
@Nodes as HostName,  
SQLInstanceName = @@SERVERNAME, 
'Yes' as IsClustered, 
CAST(SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS VARCHAR(50)) As ActiveNode, 
SERVERPROPERTY('edition') As SQLEdition, 

Case  
    when cast(serverproperty('productversion') as varchar) like '8.%' then 'SQL2000' 
    when cast(serverproperty('productversion') as varchar) like '9.%' then 'SQL2005' 
    when cast(serverproperty('productversion') as varchar)  like '10.0%' then 'SQL2008' 
    when cast(serverproperty('productversion') as varchar)  like '10.50.%' then 'SQL2008R2' 
    when cast(serverproperty('productversion') as varchar)  like '11.%' then 'SQL2012' 
    when cast(serverproperty('productversion') as varchar)  like '12.%' then 'SQL2014' 
    when cast(serverproperty('productversion') as varchar)  like '13.%' then 'SQL2016'
    ELSE 'SQL7.0' END +' '+ 
        cast(SERVERPROPERTY('productlevel') as varchar(50))+' ('+ cast(SERVERPROPERTY('productversion') as varchar(50)) + ')' as SQLVersion 
end 
else  

begin 
select @Nodes=CAST(SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS VARCHAR(50))  
select  
@Nodes as HostName,  
SQLInstanceName = @@SERVERNAME, 
'No' as IsClustered, 
SERVERPROPERTY('edition') As SQLEdition, 
Case  
  when cast(serverproperty('productversion') as varchar) like '8.%' then 'SQL2000' 
       when cast(serverproperty('productversion') as varchar) like '9.%' then 'SQL2005' 
       when cast(serverproperty('productversion') as varchar)  like '10.0%' then 'SQL2008' 
       when cast(serverproperty('productversion') as varchar)  like '10.50.%' then 'SQL2008R2' 
       when cast(serverproperty('productversion') as varchar)  like '11.%' then 'SQL2012' 
  when cast(serverproperty('productversion') as varchar)  like '12.%' then 'SQL2014' 
       ELSE 'SQL7.0' END +' '+ 
  cast(SERVERPROPERTY('productlevel') as varchar(50))+' ('+ cast(SERVERPROPERTY('productversion') as varchar(50)) + ')' as SQLVersion 
end "
$database = "master"
$wincred = Get-Credential bhnetwork\lhouc00
FOREACH($instance in GC "C:\TMP\ServerList.txt")
{
$server = Connect-DbaSqlServer -SqlInstance $instance -Credential $wincred
$server.Query($Query, $database, $true)
}