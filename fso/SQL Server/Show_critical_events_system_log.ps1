#get-winevent system -MaxEvents 100 -oldest 
#get-winevent system | where {$_.LevelDisplayName -eq "Critical"}
get-winevent system | where {$_.LevelDisplayName -eq "Error"} | out-gridview