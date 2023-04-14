$COMPUTERINFO = Get-ComputerInfo
$MANUFACTURER = $COMPUTERINFO | Select-Object -ExpandProperty CsManufacturer
$MODEL = $COMPUTERINFO | Select-Object -ExpandProperty CsModel
$SN = $COMPUTERINFO | Select-Object -ExpandProperty BiosSeralNumber
$PROCESSOR = $COMPUTERINFO | Select-Object -ExpandProperty CsProcessors | Select-Object -ExpandProperty Name
$RAM = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum) / 1gb
$DISKTYPE = (Get-PhysicalDisk | Select-Object -ExpandProperty MediaType) -replace "Unspecified"
$USR = $COMPUTERINFO | Select-Object -ExpandProperty WindowsRegisteredOwner

$newRow = "$MANUFACTURER $MODEL,$SN,$PROCESSOR,$RAM GB,$DISKTYPE,$USR"

"$newRow" | Add-Content -Path .\inv.csv