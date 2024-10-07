function Create-EventSource 
{
    param 
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $EventLogName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $EventSource
    )

    # Create the event source if not existing
    if ([System.Diagnostics.EventLog]::SourceExists($EventSource) -eq $false)
    {
        New-EventLog -LogName $EventLogName -Source $EventSource
    }
}

function Write-EventLogMessage
{
    param 
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $EventLogName,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $EventSource,
        [Parameter(Mandatory=$true, Position=2)]
        [int] $EventID,
        [Parameter(Mandatory=$true, Position=3)]
        [string] $EventType, 
        [Parameter(Mandatory=$true, Position=4)]
        [string] $EventMessage
    )

    Write-EventLog -LogName $EventLogName -Source $EventSource -EventId $EventID -EntryType $EventType -Message $EventMessage
}

$eventlog_logname = "Application"
$event_source = "PSScriptTest"
$event_id = 4000
$entry_type = [System.Diagnostics.EventLogEntryType]::Information


Create-EventSource -EventLogName $eventlog_logname -EventSource $event_source
Write-EventLogMessage -EventLogName $eventlog_logname -EventSource $event_source -EventID $event_id -EventType "Information" -EventMessage "Das ist ein Test"