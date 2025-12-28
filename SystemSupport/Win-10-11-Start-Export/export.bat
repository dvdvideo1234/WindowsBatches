@echo off

call powershell -ExecutionPolicy Bypass -command "Export-StartLayout -Path StartLayout.xml"
