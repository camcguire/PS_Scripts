# Get installed printers
$printers = Get-Printer | Select Name,PortName

# Load printers to keep
$tokeep = Import-CSV D:\Scripts\testprintershit.csv -Header ('Name','PortName')

# Set printers to be deleted
$todelete = Compare-Object $printers $tokeep -Property Name

# Delete the things
Remove-Printer -Name $todelete.Name

# Clean up after yourself
Remove-Variable printers -Force
Remove-Variable tokeep -Force
Remove-Variable todelete -force