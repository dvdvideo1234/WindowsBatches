@echo off

set "OS_VERSION=Microsoft"

for /F "usebackq tokens=3,4,5" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) do (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentVersion`) do (
  set "OS_VERSION=%OS_VERSION% %%i"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) do (
  set "OS_VERSION=%OS_VERSION%.%%i"
)

net session >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Run the script as administrator to apply the registry changes!
  goto end-script
)

echo Version: %OS_VERSION%

set "SteamAppPWD=%~dp0"
set "SteamAppPth="
set "SteamAppMod="
set "SteamAppOut=%1"
set "SteamAppNam=sourcemods"

for /F "Tokens=1,2*" %%A in ('reg query HKCU\SOFTWARE\Valve\Steam') do (
    If "%%A" equ "ModInstallPath" set "SteamAppMod=%%C"
    If "%%A" equ "SteamPath" set "SteamAppPth=%%C")

echo In order to trick steam that source mods are located on [C:\]
echo but in fact they are located on another drive the original
echo [%SteamAppNam%] must be deleted and replaced with a MKLINK!

set /p SteamAppConfirm="Continue with deletion [y/N] ? "

if /I "%SteamAppConfirm%" EQU "y" (
  set "SteamAppConfirm=Y"
)

echo [%SteamAppOut%]

if exist %1 (
  if /I "%SteamAppConfirm%" EQU "Y" (
    call cd /d "%SteamAppPth%\steamapps"
    call rmdir %SteamAppNam%
    call mklink /J %SteamAppNam% %1
    echo Steam MKLink created for: "%SteamAppPth%\steamapps\%SteamAppNam%"!
  ) else (
    echo Nothing was changed!
  )
) else (
  echo Please provide mods folder to link to!
)

cd /d %SteamAppPWD%
