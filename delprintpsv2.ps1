# Get installed printers
$printers = Get-WMIObject -Class Win32_Printer | Select Name,PortName

# Load printers to keep
$tokeep = Import-CSV D:\Scripts\testprintershit.csv -Header ('Name','PortName')

# Set printers to be deleted
$todelete = Compare-Object $printers $tokeep -Property Name

# Delete the things
Function Delete-Printers
{
	$NetworkPrinters = Get-WmiObject -Class Win32_Printer | Where-Object{$_.Name}
	If ($NetworkPrinters -ne $null)
	{
		Try
		{
			Foreach($NetworkPrinter in $todelete)
			{
				$NetworkPrinter.Delete()
				Write-Host "Successfully deleted the network printer:" + $NetworkPrinter.Name -ForegroundColor Green	
			}
		}
		Catch
		{
			Write-Host $_
		}
	}
	Else
	{
		Write-Warning "Cannot find network printer in the currently environment."
	}
}

Delete-Printers

# Clean up after yourself
Remove-Variable printers -Force
Remove-Variable tokeep -Force
Remove-Variable todelete -force