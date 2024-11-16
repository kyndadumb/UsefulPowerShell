function WriteToEventlog([string] $message)
{
    # if - source does not exist in eventlog
    if ([System.Diagnostics.EventLog]::SourceExists("BackupDriveReconnector") -eq $False) 
    {
        New-EventLog -LogName Application -Source "BackupDriveReconnector"
    }

    Write-EventLog -LogName Application -EventId 1001 -EntryType Information -Source "BackupDriveReconnector" -Message $message
}

# get all connected drive letters
$driveletters = (Get-Volume).DriveLetter

# define which driveletter should be checked
$wanted_driveletter = "D"

# if - drive already connected
if ($driveletters -contains $wanted_driveletter)
{
    # write to eventlog and end
    WriteToEventlog("Die Backupfestplatte wurde richtig erkannt.")
    break
}

# else - run reconnect
else
{
    $needToRun = $true

    # while - drive has not been found
    while ($needToRun)
    {
        # get usb-disk, NEEDS TO BE CONFIGURED INDIVIDUALLY! 
        Get-Disk | Where-Object {$_.UniqueId -like 'USBSTOR\*' -and $_.Model -ne 'Virtual HDisk0' -and $_.SerialNumber -ne 'AAAABBBBCCCC3'} | Set-Disk -IsOffline $true

        # set offline-disks back online
        Get-Disk | Where-Object {$_.IsOffline -eq $true} | Set-Disk -IsOffline $false

        # check for drive with wanted driveletter
        $drive = Get-PSDrive -name $wanted_driveletter

        # if - drive is successfully connected => stop the loop
        if($null -ne $drive)
        {
            WriteToEventlog("Die Festplatte wurde erfolgreich verbunden!")
            $needToRun = $false
        }
    } 
}