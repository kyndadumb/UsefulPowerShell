function Start-Services()
{
    param 
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $DisplayName,
        [Parameter(Mandatory=$true, Position=1)]
        [int] $Retries
    )
    
    # get all services that fit the displayname
    $services_array = Get-Service -DisplayName $DisplayName

    # foreach - loop through all found services
    foreach ($service in $services_array)
    {
        $service_started = $false
        
        # check for status = 'RUNNING' => jump to next service
        if ($service.Status -eq 'Running')
        {
            Write-Host "$($service.DisplayName) already active!"
            continue;
        }
        
        # loop for set retries
        for ($x = 1; $x -le $Retries; $x++)
        {
            # try to start the service
            Write-Host "trying to start $($service.DisplayName)"
            Start-Service -Name $service.Name
            Start-Sleep -Seconds 1
            $service.Refresh()

            # if - check for state 'RUNNING' => jump to next service 
            if ($service.Status -eq 'Running')
            {
                $service_started = $true;
                Write-Host "$($service.DisplayName) successfully started!"
                continue;
            }
        }

        # if - error needs to be shown
        if ($service_started -eq $false)
        {
            Write-Host "$($service.DisplayName) could not be started"
        }
    }
}

# run the script
Start-Services -DisplayName "*Spool*" -Retries 5