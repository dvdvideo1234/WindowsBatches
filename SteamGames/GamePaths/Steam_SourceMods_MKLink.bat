@echo off

set "OS_VERSION=Microsoft"
set "REG_SCPVER=HKLM\software\microsoft\windows NT\CurrentVersion"

for /F "usebackq tokens=3,4,5" %%i in (`REG QUERY "%REG_SCPVER%" /v ProductName`) do (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "%REG_SCPVER%" /v CurrentVersion`) do (
  set "OS_VERSION=%OS_VERSION% %%i"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "%REG_SCPVER%" /v CurrentBuild`) do (
  set "OS_VERSION=%OS_VERSION%.%%i"
)

echo Version: %OS_VERSION%

net session >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Run the script as administrator to move sourcemods!
  goto end-script
)

set "SteamAppPWD=%~dp0"
set "SteamAppPth="
set "SteamAppMod="
set "SteamAppOut=%1"
set "SteamAppNam=sourcemods"
set "SteamAppReg=HKCU\SOFTWARE\Valve\Steam"

REG QUERY %SteamAppReg% >NUL 2>NUL && (
  goto body-script
) || (
  echo Steam application is not installed. Running this is pointless!
  goto end-script
)

:body-script:

for /F "Tokens=1,2*" %%A in (`reg query "%SteamAppReg%"`) do (
    If "%%A" equ "ModInstallPath" set "SteamAppMod=%%C"
    If "%%A" equ "SteamPath" set "SteamAppPth=%%C")

echo In order to trick steam that source mods are located on [C:\]
echo but in fact they are located on another drive the original
echo [%SteamAppNam%] must be deleted and replaced with a MKLINK!

set /p SteamAppConfirm="Continue with deletion [y/N] ? "

if /I "%SteamAppConfirm%" EQU "y" (
  set "SteamAppConfirm=Y"
)

set "SteamAppSom=%SteamAppPth%\steamapps\%SteamAppNam%"

if exist "%1" (
  if /I "%SteamAppConfirm%" EQU "Y" (
    dir /b /s /a "%SteamAppSom%" | findstr .>nul && (
      echo Origin not empty: "%SteamAppSom%"
      echo Please move the source mods folder to the new location first!
    ) || (
      call cd /d "%SteamAppPth%\steamapps"
      call rmdir %SteamAppNam%
      call mklink /J %SteamAppNam% %1
      echo Steam MKLink created for: "%SteamAppSom%"
      echo Steam MKLink destination: "%1"
    )
  ) else (
    echo Nothing was changed!
  )
) else (
  echo Destination invalid: "%1"
  echo Please provide valid source mods folder to link to!
)

cd /d %SteamAppPWD%

:end-script:
