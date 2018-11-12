# be careful not to delete folder and new files in E:\DATA\databases\FC_T_ERP_BHERPDB\fc\streams\cdc
$dir = "E:\DATA\databases\FC_T_ERP_BHERPDB\fc\streams\"
$day = "100"
Get-ChildItem -Path $dir | Where-Object {$_.PSIsContainer -eq $true -and $_.CreationTime -lt (get-date).adddays(-$day)} | Remove-Item -Recurse -Force -Verbose

