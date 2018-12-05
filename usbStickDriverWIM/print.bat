@echo off

set dismPath=%~dp0
set dismFile=%1

call dism /Get-WimInfo /WimFile:%dismPath%%dismFile%.wim

timeout 500
