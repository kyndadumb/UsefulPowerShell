function Start-Services()
{
    param 
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $DisplayName,
        [Parameter(Mandatory=$true, Position=1)]
        [int] $Retries
    )
    
    $services_array = Get-Service -DisplayName $DisplayName

    foreach ($service in $services_array)
    {
        $service_started = $false
        
        if ($service.Status -eq 'Running')
        {
            Write-Host "$($service.DisplayName) already active!"
            continue;
        }
        
        for ($x = 1; $x -le $Retries; $x++)
        {
            Write-Host "trying to start $($service.DisplayName)"
            Start-Service -Name $service.Name
            Start-Sleep -Seconds 1
            $service.Refresh()

            if ($service.Status -eq 'Running')
            {
                $service_started = $true;
                Write-Host "$($service.DisplayName) successfully started!"
                continue
            }
        }

        if ($service_started -eq $false)
        {
            "$($service.DisplayName) could not be started"
        }
    }
}


Start-Services -DisplayName "*Warteschlange*" -Retries 5