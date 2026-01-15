@echo off

call powershell -ExecutionPolicy Bypass -command "Export-StartLayout -Path StartLayout.json"

:: call powershell -ExecutionPolicy Bypass -command "Export-StartLayout -UseDesktopApplicationID -Path StartLayout.xml"

:: %LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState

