# Python-Installer herunterladen
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.0/python-3.11.0.exe" -OutFile "c:/inst/python-3.11.0.exe" -UseBasicParsing

# Python installieren
c:/inst/python-3.11.0.exe /quiet InstallAllUsers=1 PrependPath=1

# Path-Variable setzen
$env:Path += ';C:\Program Files (x86)\Python311-32'