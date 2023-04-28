$COMPUTERINFO = Get-ComputerInfo
$MANUFACTURER = $COMPUTERINFO | Select-Object -ExpandProperty CsManufacturer
$MODEL = $COMPUTERINFO | Select-Object -ExpandProperty CsModel
$SN = $COMPUTERINFO | Select-Object -ExpandProperty BiosSeralNumber
$PROCESSOR = $COMPUTERINFO | Select-Object -ExpandProperty CsProcessors | Select-Object -ExpandProperty Name
$RAM = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum) / 1gb
$DISKTYPE = (Get-PhysicalDisk | Select-Object -ExpandProperty MediaType) -replace "Unspecified"
$USR = $COMPUTERINFO | Select-Object -ExpandProperty WindowsRegisteredOwner

$newRow = "$MANUFACTURER $MODEL,$SN,$PROCESSOR,$RAM GB,$DISKTYPE,$USR"

"$newRow" | Add-Content -Path .\inventario.csv

function Decode {
    If ($args[0] -is [System.Array]) {
        [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    Else {
        "Not Found"
    }
}
ForEach ($Monitor in Get-WmiObject WmiMonitorID -Namespace root\wmi) {  
    $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
    $Name = Decode $Monitor.UserFriendlyName -notmatch 0
    $Serial = Decode $Monitor.SerialNumberID -notmatch 
	
    $NewRow2 = "$Manufacturer, $Name, $Serial"
    "$NewRow2" | Add-Content -Path .\monitor.csv
}
