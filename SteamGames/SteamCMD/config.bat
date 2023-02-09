:: config.bat update 4020
:: setlocal EnableExtensions EnableDelayedExpansion

@echo off

set SCMDPATH=%~dp0
set SCMDACTION=%1
set SCMDLOGFILE=%SCMDPATH%steamcmd.log

echo This script manages SteamCMD dedicated server

:: Refresh stuff regarding the installation
if exist steamcmd.zip (
  del steamcmd.zip
)

if exist steamcmd.exe (
  del steamcmd.exe
)

if exist %SCMDLOGFILE% (
  del %SCMDLOGFILE%
)

:: Remove some folders
rd /S /Q logs
rd /S /Q package

timeout 2 /nobreak

bitsadmin /transfer jobSteamCMD /download /priority normal https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip %SCMDPATH%steamcmd.zip
unzip steamcmd.zip
call %SCMDPATH%steamcmd.exe > %SCMDLOGFILE%

set /p SCMDBOOLEAN="Do you wish to login now [y/N] ? "

if "%SCMDBOOLEAN%"=="y" (
  set /p SCMDLOGIN="Write a steam user, or press [Enter] for anonymous: "
  echo "User1: <%SCMDLOGIN%>"
  if not defined %SCMDLOGIN% (
    set SCMDLOGIN=anonymous
  )
  echo "User2: <%SCMDLOGIN%>"
) else (
  call %SCMDPATH%steamcmd.exe +quit >> %SCMDLOGFILE%
)

set /p SCMDAPPID="Select server application to be installed: "

if not defined %SCMDAPPID% (
  echo Application ID not provided. Please provide now!
  set /p SCMDAPPID="Application ID: "

  if not defined %SCMDAPPID% (
    echo No application ID proveded. Better luck next time!
    timeout 10
   :: exit 0
  )
)
echo "AppID: <%SCMDAPPID%>"

if "%SCMDLOGIN%"=="" (
  echo You can not pass this point without login !
  timeout 50
 :: exit 0
)


timeout 500