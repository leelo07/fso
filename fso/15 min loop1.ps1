$x=1
while ($x -lt 15){
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
[Windows.Forms.Cursor]::Position = "$($screen.Width),$($screen.Height)"
Start-Sleep -s 59
$x=$x+1
}