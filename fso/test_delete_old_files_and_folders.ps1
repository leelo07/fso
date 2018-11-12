# NOTE: Be careful as this script is NOT reliable!!!
$dir = "C:\@attunity\"
$day = "200"
Get-ChildItem -Path $dir | Where-Object {$_.PSIsContainer -ne $true -and $_.CreationTime -lt (get-date).adddays(-$day)} | Remove-Item -Recurse -Force -Verbose

