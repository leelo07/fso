# Dir $home -recurse -ea SilentlyContinue |   
Dir c:\ -recurse -ea SilentlyContinue |   
Sort-Object Length -Descending |   
Select-Object -first 100 |   
Select-Object FullName, Length, LastWriteTime  |
export-csv $home\newfile.csv                    