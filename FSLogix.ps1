write-host "Configuring FSLogix"

# Define variables for Storage and File Share Locations

$DUBfileServer="dubavdstor1.file.core.windows.net"
$DUBprofileShare=\\$($DUBfileServer)\neavdshare

$WEfileServer="weavdstor1.file.core.windows.net"
$WEprofileShare=\\$($WEfileServer)\weavdshare

# Define variables for Storage Account Keys

$DUBuser="localhost\dubavdstor1"
$DUBsecret="******************"

$WEuser="localhost\weavdstor1"
$WEsecret="******************"


New-Item -Path "HKLM:\SOFTWARE" -Name "FSLogix" -ErrorAction Ignore

New-Item -Path "HKLM:\SOFTWARE\FSLogix" -Name "Profiles" -ErrorAction Ignore

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "Enabled" -Value 1 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "CCDLocations" -Value "type=smb,connectionString=$NEprofileShare;type=smb,connectionString=$WEprofileShare" -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "ConcurrentUserSessions" -Value 1 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "DeleteLocalProfileWhenVHDShouldApply" -Value 1 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "FlipFlopProfileDirectoryName" -Value 1 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "IsDynamic" -Value 1 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "KeepLocalDir" -Value 0 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "ProfileType" -Value 0 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "SizeInMBs" -Value 2000 -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "VolumeType" -Value "VHDX" -force

New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "AccessNetworkAsComputerObject" -Value 1 -force

 
# Store credentials on each host to access the storage account

cmdkey.exe /add:$DUBfileServer /user:$($DUBuser) /pass:$($DUBsecret)

cmdkey.exe /add:$WEfileServer /user:$($WEuser) /pass:$($WEsecret)

# Disable Windows Defender Credential Guard (only needed for Windows 11 22H2)

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LsaCfgFlags" -Value 0 -force

write-host "The script has finished."
