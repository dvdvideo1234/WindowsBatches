@echo off

call powershell -ExecutionPolicy Bypass -command "Get-AppxPackage | Select Name, PackageFullName | Out-Host" > current_apps.txt

