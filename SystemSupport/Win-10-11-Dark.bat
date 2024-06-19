@echo off

set "REG_THM=HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"

call powershell New-ItemProperty -Path %REG_THM% -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
call powershell New-ItemProperty -Path %REG_THM% -Name AppsUseLightTheme    -Value 0 -Type Dword -Force

call taskkill /f /im explorer.exe
call start explorer.exe

exit 0
