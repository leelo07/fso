Get-Process | Select-Object -Property Name, WorkingSet, CPU | Sort-Object -Property CPU -Descending |
 Out-GridView -PassThru | Export-Csv -Path c:\users\lhouc00\ProcessLog.csv