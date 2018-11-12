$x=0
while ($x -lt 30){
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
[Windows.Forms.Cursor]::Position = "$($screen.1),$($screen.1)"
[Windows.Forms.Cursor]::Position = "$($screen.Width),$($screen.Height)"
Start-Sleep -s 60
$x=$x+1
}