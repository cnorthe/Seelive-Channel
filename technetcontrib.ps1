New-Item -ItemType directory -Path c:\Client

Copy-Item -path \\SCCMServerName\c$\Client\* -Destination c:\Client

cd c:\Client

.\ccmsetup.exe /mp:SCCMServerName.domain SMSSITECODE=ABC