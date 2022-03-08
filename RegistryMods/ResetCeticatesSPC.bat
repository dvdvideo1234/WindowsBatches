@echo off

set "REG_SCPKEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC"
set "REG_SPCFAV=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites"

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

set /p REG_CHANGE="Apply registry changes [y/N] ? "

if /I "%REG_CHANGE%" EQU "y" (
  set "REG_CHANGE=Y"
)

set /p REG_FAVOR="Save to favorites [y/N] ? "

if /I "%REG_FAVOR%" EQU "y" (
  set "REG_FAVOR=Y"
)

if /I "%REG_FAVOR%" EQU "Y" (
  REG ADD %REG_SPCFAV% /v "SPC" /t REG_SZ /d %REG_SCPKEY% /f
  echo Registry location added to favorites!
)

if /I "%REG_CHANGE%" EQU "Y" (
  echo Registry modification requested!
  REG QUERY %REG_SCPKEY%\Certificates >NUL 2>NUL && (
    echo Registry modification completed!
    REG DELETE %REG_SCPKEY%\Certificates /f
  )
) else (
  echo Registry modification canceled!
)

:end-script

timeout 100
