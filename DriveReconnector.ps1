function WriteToEventlog([string] $message)
{
    # if - Eventlogquelle existiert noch nicht
    if ([System.Diagnostics.EventLog]::SourceExists("BackupDriveReconnector") -eq $False) 
    {
        New-EventLog -LogName Application -Source "BackupDriveReconnector"
    }

    Write-EventLog -LogName Application -EventId 1001 -EntryType Information -Source "BackupDriveReconnector" -Message $message
}

# vorhandene Laufwerke prüfen
$driveletters = (Get-Volume).DriveLetter
$wanted_driveletter = "D"

# if - Festplatte ist bereits richtig verbunden?
if ($driveletters -contains $wanted_driveletter)
{
    # Meldung ins Eventlog schreiben und beenden
    WriteToEventlog("Die Backupfestplatte wurde richtig erkannt.")
    break
}

# else - Skript muss ausgeführt werden
else
{
    $needToRun = $true

    # while - needToRun ist true (wird erst false wenn das Laufwerk korrekt ermittelt wurde)
    while ($needToRun)
    {
        # angeschlossene USB-Disk holen und Offline setzen
        Get-Disk | Where-Object {$_.UniqueId -like 'USBSTOR\*' -and $_.Model -ne 'Virtual HDisk0' -and $_.SerialNumber -ne 'AAAABBBBCCCC3'} | Set-Disk -IsOffline $true

        # alle USB-Disks die offline sind wieder Online schalten
        Get-Disk | Where-Object {$_.IsOffline -eq $true} | Set-Disk -IsOffline $false

        # Drive laden
        $drive = Get-PSDrive -name $wanted_driveletter

        # if - Laufwerk ist vorhanden
        if($null -ne $drive)
        {
            WriteToEventlog("Die Festplatte wurde erfolgreich verbunden!")
            $needToRun = $false
        }
    } 
}