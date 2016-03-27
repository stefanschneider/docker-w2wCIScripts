#-----------------------
# SetupNSSM.ps1
#-----------------------


# Stop on error
$ErrorActionPreference="stop"


# Create directory for storing the nssm configuration
mkdir $env:ProgramData\docker -ErrorAction SilentlyContinue


# Install NSSM by extracting archive and placing in system32
$wc=New-Object net.webclient;$wc.Downloadfile("https://raw.githubusercontent.com/jhowardmsft/docker-w2wCIScripts/master/nssmdocker.W2WCIServers.cmd","$env:ProgramData\docker\nssmdocker.cmd")
$wc=New-Object net.webclient;$wc.Downloadfile("https://nssm.cc/release/nssm-2.24.zip","$env:Temp\nssm.zip")
Expand-Archive -Path $env:Temp\nssm.zip -DestinationPath $env:Temp
Copy-Item $env:Temp\nssm-2.24\win64\nssm.exe $env:SystemRoot\System32


# Configure the docker NSSM service
mkdir $env:Programdata\docker -erroraction SilentlyContinue
Start-Process -Wait "nssm" -ArgumentList "install docker $($env:SystemRoot)\System32\cmd.exe /s /c $env:Programdata\docker\nssmdocker.cmd < nul"
Start-Process -Wait "nssm" -ArgumentList "set docker DisplayName Docker Daemon"
Start-Process -Wait "nssm" -ArgumentList "set docker Description Docker control daemon for CI testing"
Start-Process -Wait "nssm" -ArgumentList "set docker AppStderr $env:Programdata\docker\nssmdaemon.log"
Start-Process -Wait "nssm" -ArgumentList "set docker AppStdout $env:Programdata\docker\nssmdaemon.log"
Start-Process -Wait "nssm" -ArgumentList "set docker AppStopMethodConsole 30000"

