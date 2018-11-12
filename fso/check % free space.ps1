1. ###############################################################################
2. # Check the percentage of free space, including mount points
3. ###############################################################################
4. # For use in sending alerts via SQL Server Database Mail and may be scheduled
5. # via a SQL Server Agent job. Create a new Agent job and creat a new step, set
6. # the Type as PowerShell, edit the code below to put in your server name(s),
7. # Database Mail profile name, and recipient email address(es), optionally
8. # change the warning threshold, then paste the code into the Command pane and
9. # create a schedule.
10. ###############################################################################
11.
12. # List the servers you want to check for low disk capacities
$ServerArray = @('LWBHN00002028')
14. # Server names (not SQL Server instance names) must be in single quotes and
15. # separated by commas. If the SQL Server Agent service account does not have
16. # admin permissions on remote servers, you must assign Remote Execute
17. # permissions to the Agent account on each remote server, and the Agent account
18. # must be a domain account. To assign Remote Execute, run wmimgmt.msc,
19. # right‐click/Properties, select the Security tab, expand the Root node, select
20. # the CIMV2 node, click the Security button, add the Agent account and scroll
21. # down to find and check the box for the "Remote Enable" permission.
22.
23. # Set threshold percentage for low disk capacity warnings.
$Threshold = .15
25. # Threshold value must be between 0 and 1.
26. # (E.g. ".1" will produce warnings when free space is below 10%.
27.
28. # Set values for units of measure
[string]$UnitOfMeasure = '1GB'
$UnitOfMeasureTerm = "GB"
# Use an empty string for bytes or KB/MB/GB/TB/PB
# (KB‐PB are constants in PowerShell)
ForEach ($ServerName in $ServerArray)
{
$Volumes = Get‐WmiObject ‐namespace "root/cimv2" ‐computername $ServerName ‐query "SELECT Name, Capacity, FreeSpace FROM Win32_Volume WHERE DriveType = 2 OR DriveType = 3"

ForEach ($Volume in $Volumes)
{
[string]$DriveType = Switch($Volume.DriveType)
{
0{'Unknown'}
1{'No Root Directory'}
2{'Removable Disk'}
3{'Local Disk'}
4{'Network Drive'}
5{'Compact Disk'}
6{'RAM Disk'}
default {'Unknown'}
}
[string]$Drive = "Drive: {0}" ‐f$Volume.Name
[string]$Capacity = "Capacity: {0} {1}" ‐f[System.Math]::Round(($Volume.Capacity / $UnitOfMeasure),0), $UnitOfMeasureTerm
[string]$FreeSpace = "Free Space: {0} {1}" ‐f[System.Math]::Round(($Volume.FreeSpace / $UnitOfMeasure),0), $UnitOfMeasureTerm
[string]$PercentFree = "Percent Free Space: " + [System.Math]::Round(($Volume.FreeSpace / $Volume.Capacity), 2)*100 + "%"
# Send an email alert via Database Mail if a disk is below the warning threshold
If ($Volume.FreeSpace / $Volume.Capacity ‐lt $Threshold)
{
$Qry = "EXECUTE msdb.dbo.sp_send_dbmail @profile_name = 'DBA',
@recipients = 'leigh.houck@bhnetwork.com',
@subject = 'Low Disk Capacity Warning',
@body_format = 'text',
@body = 'WARNING: Low free space on " + $ServerName.ToUpper() + ".
" + $Drive + "
" + $Capacity + "
" + $FreeSpace + "
" + $PercentFree + "'"
# Replace <sqlprofilename> with the name of the Database Mail profile name.
# Replace <emailaddress> with who you want the email to go to.
# Changing the formatting of $Qry will change the format of the email.
Invoke‐SqlCmd ‐query $Qry ‐ServerInstance "localhost"
# If the local instance of SQL Server is a named instance, use the
# "DOMAIN\InstanceName" in place of 'localhost'.
}
#12/16/2015 Check disk free space including mount points.ps1 2/2
###########################################################################
# If you'd like to get a disk capacity report interactively, comment‐out
# the If statement above and comment‐in the following If statement:
#If ($Volume.FreeSpace / $Volume.Capacity ‐lt .1)
#{
# Write‐Output "WARNING: Disk capacity is less than 10%"
# Write‐Output $Drive
# Write‐Output $Capacity
# Write‐Output $FreeSpace
# Write‐Output $PercentFree
#}
#Else
#{
# Write‐Output $Drive
# Write‐Output $Capacity
# Write‐Output $FreeSpace
# Write‐Output $PercentFree
#}
    } 
}