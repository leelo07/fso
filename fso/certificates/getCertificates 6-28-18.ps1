﻿get-childitem -Path Cert:\LocalMachine -Recurse | Where-Object {$_.psiscontainer -eq $false} | Format-List -Property *