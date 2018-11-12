$d = "Computer"
Get-ADComputer -Filter ‘ObjectClass -eq $d' | select name | ft -HideTableHeaders > H:exportServers.txt