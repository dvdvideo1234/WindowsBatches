@echo off

call powershell -ExecutionPolicy Bypass -command "Export-StartLayout -Path StartLayout.json"

rem call powershell -ExecutionPolicy Bypass -command "Export-StartLayout -UseDesktopApplicationID -Path StartLayout.xml"

rem %LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState

