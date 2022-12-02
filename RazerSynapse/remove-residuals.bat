@echo off

Setlocal EnableDelayedExpansion

set RazerFolders[1]="C:\ProgramData\Razer"
set RazerFolders[2]="C:\Program Files\Razer"
set RazerFolders[3]="C:\Program Files (x86)\Razer"
set RazerFolders[4]="C:\Program Files (x86)\Razer Chroma SDK"
set RazerFolders[5]="%USERPROFILE%\AppData\Local\Razer"
set RazerFolders[6]="%USERPROFILE%\AppData\Roaming\Synapse"

set RazerCount=6

FOR /L %%r IN (1, 1, !RazerCount!) do (
  echo Erasing: !RazerFolders[%%r]!
  IF EXIST !RazerFolders[%%r]! RMDIR /S /Q !RazerFolders[%%r]!
)

