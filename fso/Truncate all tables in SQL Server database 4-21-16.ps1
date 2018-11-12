# This script is to truncate all tables in a database
# Author: Jeffrey Yao | 2016/03/15
# requires -version 3.0

import-module sqlps -DisableNameChecking;
set-location c:\;
# change the following three variables according to your environment needs
[string]$mach = $env:COMPUTERNAME;
[string]$sql_instance = 'default';
[string]$DBname = 'AW2012';

$svr = get-item "sqlserver:\sql\$mach\$sql_instance"

[String]$FT_index='';

[Microsoft.SqlServer.Management.Smo.Database]$db = get-item "sqlserver:\sql\$mach\$sql_instance\databases\$($DBname)"; # AW2012 

# This script is to truncate all tables in a database
# Author: Jeffrey Yao | 2016/03/15

import-module sqlps -DisableNameChecking;
set-location c:\;
# change the following three variables according to your environment needs
[string]$mach = $env:COMPUTERNAME;
[string]$sql_instance = 'default';
[string]$DBname = 'AW2012';

$svr = get-item "sqlserver:\sql\$mach\$sql_instance"

[String]$FT_index='';

[Microsoft.SqlServer.Management.Smo.Database]$db = get-item "sqlserver:\sql\$mach\$sql_instance\databases\$($DBname)"; # AW2012 
$db.tables.Refresh();

#script out FKs and save it to variable $fk_script
$db.tables | % -begin {[string]$fk_script=''} -process {$_.foreignkeys.refresh(); $_.foreignkeys | % {$fk_script +=$_.script() +";`r`n"} }

#drop foreign keys

$db.tables | % -begin {$fks=@()} -process { $fks += $_.ForeignKeys  };
foreach ($fk in $fks) {$fk.drop();}


$spt = new-object -TypeName "microsoft.sqlserver.management.smo.scripter" -ArgumentList $svr;

$spt.Options.WithDependencies = $true;

$so = new-object "microsoft.sqlserver.management.smo.scriptingoptions";
$so.DriPrimaryKey = $true;
$so.DriIndexes = $true;
$so.Indexes=$false;
$so.FullTextIndexes = $false;

foreach ($t in $db.tables )
{
    #we will check whether this table isSchemaBound by views/udfs
    #if yes, we will need to create a duplicate table with different table names, constraint names 
    #and then use "alter table ... switch .. " to do the trunation work
    #otherwise, we can simple do a truncate table

    $t.refresh();
    $dpt = $spt.DiscoverDependencies($t, $false);
    $collection=$spt.WalkDependencies($dpt);

    if ($collection.count -gt 1) 
    {
        if ($t.FullTextIndex -ne $null) # if there is FT index, we will drop it first
        {
            $t.FullTextIndex | % -Begin {$FTx=@();} -process {$FT_index += $_.script(); $FTx +=$_;}
            foreach($f in $FTx) {$f.drop();}
            
        }

        [string]$ts=$t.script($so) -join "`r`n";
        $t.indexes | ? { ! ($_.isXmlIndex -or $_.isSpatialIndex -or ($_.IndexKeyType -eq 'DRIPrimaryKey'))} | % {$ts +=$_.script() + "`r`n"}

        $ts = $ts -replace "\sCONSTRAINT \[(\w+)]\s", ' CONSTRAINT [$1_x] '; # you must use the signle quote here
        
        $ts = $ts -replace "\sINDEX \[(\w+)]\s", ' INDEX [$1_x] ';
        $ts = $ts -replace "\[$($t.schema)]\.\[$($t.name)]", "[$($t.schema)].[$($t.name)_x]";
        try 
	    {   $db.ExecuteNonQuery($ts);
	        $qry = "alter table [$($t.schema)].[$($t.name)] switch to  [$($t.schema)].[$($t.name)_x];"
	        $qry;
	        
	        $db.ExecuteNonQuery($qry);
	        $qry = "drop table [$($t.schema)].[$($t.name)_x];"
	        $db.ExecuteNonQuery($qry);
	
	        #add back the FullText Index
	        if ($FT_index.Length -gt 0)
	        { $db.ExecuteNonQuery($FT_index); $FT_index = '';}
	    }
        catch
        {
            write-host "error running: $qry" -ForegroundColor Red;
        }
    } #$colletion.count -gt 1
    else
    { $t.TruncateData(); #direct truncate
      write-host "truncate table [$($t.Schema)].[$($t.name)]" -ForegroundColor yellow
    }
}

# resetup the FKs
$db.ExecuteNonQuery($fk_script);
$db = $null;
$svr = $null;

