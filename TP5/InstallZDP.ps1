#-----------------------
# InstallZDP.ps1
#-----------------------

$ErrorActionPreference='Stop'

echo "$(date) InstallZDP.ps1 started" >> $env:SystemDrive\packer\configure.log

try {
    
    # 4D 
    # echo "$(date) InstallZDP.ps1 Installing 4D ZDP silently (needs reboot)..." >> $env:SystemDrive\packer\configure.log
    #Start-Process -Wait "c:\zdp\4D\Windows10.0-KB3157663-x64.msu" -ArgumentList "/quiet /norestart"

    # 5B
    echo "$(date) InstallZDP.ps1 Installing 5B ZDP silently (needs reboot)..." >> $env:SystemDrive\packer\configure.log
    Start-Process -Wait "c:\zdp\5B\Windows10.0-KB3158987-x64.msu" -ArgumentList "/quiet /norestart"
}
Catch [Exception] {
    echo "$(date) InstallZDP.ps1 complete with Error '$_'" >> $env:SystemDrive\packer\configure.log
    Throw $_
}
Finally {
    echo "$(date) InstallZDP.ps1 complete successfully at $(date)" >> $env:SystemDrive\packer\configure.log
}    