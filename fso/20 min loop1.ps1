$x=0
while ($x -lt 15){
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
[Windows.Forms.Cursor]::Position = "$($screen.Width),$($screen.Height)"
Start-Sleep -s 120
$x=$x+1
}