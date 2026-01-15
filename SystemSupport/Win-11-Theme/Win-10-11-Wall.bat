@echo off

call powershell.exe -NoProfile -ExecutionPolicy Bypass -File "Scripts\ChangeWallpaper.ps1" "%1"

timeout 100
