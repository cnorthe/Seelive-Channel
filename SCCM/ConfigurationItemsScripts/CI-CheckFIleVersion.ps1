$ComputerModels = 'HP EliteBook 820 G3','HP EliteBook 840 G3'
$FilePath = "C:\Program Files\Lenovo\HOTKEY\kbdmgr.exe"
$FileVersion = "1.0.0.11"
$ComputerModelWMI = (Get-WmiObject Win32_ComputerSystem).Model
if ($ComputerModels -match $ComputerModelWMI) {
    $ActualFileVersion = (Get-ChildItem $FilePath).VersionInfo
    $ActualFileVersion = $ActualFileVersion.FileVersion
    if ($ActualFileVersion -eq $FileVersion) {
        Write-Output $true
    }
    else {
        Write-Output $false
    }
}
else {
   Write-Output $true
}