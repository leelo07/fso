Get-ChildItem -path C:\ -recurse | Where-Object { Test-Path -Path $_.PSPath -PathType Leaf } | Where-Object { $_.Length -gt 50000} | Sort-Object -property length -Descending

