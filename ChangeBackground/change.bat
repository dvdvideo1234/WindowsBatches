:: https://ss64.com/nt/if.html

@echo off

setlocal EnableDelayedExpansion

net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights^^! & goto SUB_EXIT)

set "changeBase=%~dp0"
set "changeSize=%~z1"
set "changeFile=%~n1"
set "changeExtn=%~x1"
set "changeBack=backgroundDefault"
set "changeReg=hklm\software\microsoft\windows NT\CurrentVersion"
set "changeOEM=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background"
set "changeVOS=Microsoft"

for /F "usebackq tokens=3,4,5" %%i in (`REG query "!changeReg!" /v ProductName`) do (
  set "changeVOS=!changeVOS! %%i %%j %%k"
)

for /F "usebackq tokens=3" %%i in (`REG query "!changeReg!" /v CurrentVersion`) do (
  set "changeVOS=!changeVOS! %%i"
)

for /F "usebackq tokens=3" %%i in (`REG query "!changeReg!" /v CurrentBuild`) do (
  set "changeVOS=!changeVOS!.%%i"
)

echo Running: !changeVOS!

set /p changeBool="Apply picture change [y/N] ? "

if /I not "%changeBool%" EQU "Y" (
  goto SUB_REGISTRY
)

echo Background image will be changed to [!changeFile!!changeExtn!]^^!

if [!changeFile!] EQU [] (
  echo The input file image is missing^^!
  goto SUB_EXIT
)

if !changeSize! GTR 256000 (
  echo The input file exceeds 250KB^^!
  goto SUB_EXIT
)

if not [!changeExtn!] EQU [.jpg] (
  echo The input file extension is [!changeExtn!]^^!
  goto SUB_EXIT
)

cd /d "C:\Windows\System32"

:: Setup C:\Windows\System32\oobe\info\backgrounds

if not exist "oobe" mkdir "oobe"
if not exist "oobe\info" mkdir "oobe\info"
if not exist "oobe\info\backgrounds" mkdir "oobe\info\backgrounds"

xcopy "!changeBase!!changeFile!!changeExtn!" "C:\Windows\System32\oobe\info\backgrounds\!changeBack!!changeExtn!"* /i /c /f /y /h /r

:SUB_REGISTRY

set /p changeBool="Enable custom background [y/N] ? "

if /I "%changeBool%" EQU "Y" (
  REG ADD !changeOEM! /f /v "OEMBackground" /t REG_DWORD /d "1"
) else (
  REG ADD !changeOEM! /f /v "OEMBackground" /t REG_DWORD /d "0"
)

:SUB_EXIT

timeout 500
