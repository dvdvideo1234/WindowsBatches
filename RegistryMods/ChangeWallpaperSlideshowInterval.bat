@echo off

setlocal EnableDelayedExpansion

set "OS_VERSION=Microsoft"

for /F "usebackq tokens=3,4,5" %%i in (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) do (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

for /F "usebackq tokens=3" %%i in (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentVersion`) do (
  set "OS_VERSION=%OS_VERSION% %%i"
)

for /F "usebackq tokens=3" %%i in (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) do (
  set "OS_VERSION=%OS_VERSION%.%%i"
)

echo %OS_VERSION%
echo Please run the script as administrator to apply the registry changes!

set /p REG_TIMESS="Enter time in miliseconds : "
set /a REG_NUMBER=!REG_TIMESS!

if /I "!REG_NUMBER!" EQU "" (
  echo Variable confartion failed
  set /a REG_NUMBER=0
)

if !REG_NUMBER! GTR 0 (
  echo Slideshow changed to: [!REG_NUMBER!]
  REG ADD "HKEY_CURRENT_USER\Control Panel\Personalization\Desktop Slideshow" /f /v "Interval" /t REG_DWORD /d "!REG_NUMBER!"
) else (
  echo Time value invalid: [!REG_TIMESS!][!REG_NUMBER!]
)

timeout 100
