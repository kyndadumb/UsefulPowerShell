# UsefulPowerShell
Useful Powershell Scripts for certain (windows) functions

## DriveReconnector.ps1
- script for trying to reconnect a usb drive by setting it offline/online until it's recognized
- driveletter needs to be set in line 16 and the search conditions in line 35 need to be changed
- the execution stops when the drive is online

## PythonInstaller.ps1
- simple script for downloading and installing python
- link in line 3 and path in line 9 need to be changed for new versions

## Start-RequiredServices.ps1
- script for trying to start a windows service/services
- displayname (line 53) can be the real name or wildcard search like "\*XBOX\*"

## Write-ToEventlog
- better method for creating sources and entries for windows eventlog