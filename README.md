About:

Packer bits for building Windows images (@jhowardmsft)
------------------------------------------------------

- packer.json - The packer configuration file
- packer.ps1  - Powershell wrapper for running the image build.

Usage:
------
    - $env:password="The Password You Want"
    - .\packer.ps1


Notes:
------

- Need publish settings in $env:HOME\.azure\engine-team@docker.com.publishsettings
  Get-AzurePublishSettingsFile and save to above location.

- Download Windows 64-bit packer from https://www.packer.io/downloads.html
  (This was verified using version 0.10.0). Extract to e:\packer
  
- Copy the two files at the top to the directory (or have e:\packer in path)

- Download Packer-Azure from https://github.com/Azure/packer-azure and
  extract to the same directory. Direct link https://github.com/Azure/packer-azure/releases

- Make sure your azure credentials are set.   (Add-AzureAccount for engine-team@docker.com)

- Check packer.json is pointing to the correct image you have prepared. At the
  time of writing, there is a "tp5" storage container on the engine account on Azure.
  It contains a sysprepped VHD of TP5 with:
  
  - Base OS images for nanoserver and windowsservercore
  - Container role added
  - TP5 workarounds added (see below)
  - Sysprepped
  - Uploaded (Add-AzureVHD "https://tp5.blob.core.windows.net/vhds/azuretp5v2.vhd") where
    - tp5 in the URL is the name of the storage container in Azure
    - v2 in azuretp5v2.vhd represents the version of the VHD. Increment each rebuild.
  - Image created (Add-AzureVMImage -imagename azuretp5v2 -MediaLocation https://tp5.blob.core.windows.net/vhds/azuretp5v2.vhd -OS Windows)
  


- Keep the imageName handy as you'll need that to create a new VM from that image.
  
- IMPORTANT: The BringNodeOnline/TakeNodeOffline scripts rely on the Jenkins nodes being
             called azure-windows-tp5-n, and the computer names themselves being named
             jenkins-tp5-n. 

TP5 workarounds:
----------------
 
 In base VHD: 
 - BringNodeOnline.ps1 and TakeNodeOffline.ps1 added to c:\scripts.
   These are NOT in github due to containing API key. Can be found on \\redmond\osg\....team\jhoward\docker\ci\TP5
 - Scheduled task at system startup to run BringNodeOnline.ps1
  
 In PostSysprep.ps, netsh int ipv4 reset. This should not be necessary
   with the final TP5+ZDP.
 
 In Jenkins
 - At job launch, calls c:\scripts\TakeNodeOffline.ps1
 - At job completion, calls shutdown /t 0 /r
 - Debatable for reliability if these should remain in....
 


