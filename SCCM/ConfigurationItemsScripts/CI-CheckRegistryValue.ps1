##Check Registry Value

$ComputerModels = 'HP EliteBook 820 G3','HP EliteBook 840 G3'
$RegistryVersion = "24.20.100.628"
$ComputerModelWMI = (Get-WmiObject Win32_ComputerSystem).Model
if ($ComputerModels -match $ComputerModelWMI) {
    $ActualRegistryVersion = (Get-ItemProperty HKLM:\Software\WOW6432Node\Intel\GFX).Version
    if ($ActualRegistryVersion -ge $RegistryVersion) {
        Write-Output $true
    }
    else {
        Write-Output $false
    }
}
else {
   Write-Output $true
}