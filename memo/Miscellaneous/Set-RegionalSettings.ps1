Import-Module International
$LocaleName = "fr-FR"

if ($LocaleName -notin $((Get-WmiObject -Class Win32_OperatingSystem).MUILanguages)) {
    throw "Locale $LocaleName is not installed on this system"
}

$GeoId = ([System.Globalization.RegionInfo]$LocaleName).GeoId
Set-WinSystemLocale $LocaleName
Set-WinHomeLocation -GeoId $GeoId
Set-Culture $LocaleName
Set-WinUserLanguageList $LocaleName -Force

New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$RegKeyPath = "HKU:\*\Control Panel\International"
$UserRegionalSettings = Get-ItemProperty $RegKeyPath
$SettingsTemplate = $UserRegionalSettings | Where-Object 'localename' -eq $LocaleName | Select-Object -First 1

foreach ($usersetting in $UserRegionalSettings) {
    if ($usersetting.localename -ne $LocaleName) {
        foreach ($props in $usersetting.psobject.Properties) {
            if (($props.name -notin @("PSPath", "PSParentPath", "PSchildName", "PSDrive", "PSProvider")) -and ($SettingsTemplate.$($props.name))) {
                Set-ItemProperty $usersetting.PSPath -Name $props.name -Value $SettingsTemplate.$($props.name)
            }
        }
    }
}

# Need to find a way to do this : https://docs.microsoft.com/en-us/powershell/module/international/copy-userinternationalsettingstosystem?view=windowsserver2022-ps
# Copy-UserInternationalSettingsToSystem
# Issue : Command does not even exists on Windows Server 2022 nor psv7

Restart-Computer -Force -Confirm
