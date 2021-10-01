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

echo %OS_VERSION%
echo Please run the script as administrator to apply the registry changes!

set /p REG_CHANGE="Apply registry changes [y/N] ? "

if /I "%REG_CHANGE%" EQU "y" (
  set "REG_CHANGE=Y"
)

set /p REG_FAVOR="Save to favorites [y/N] ? "

if /I "%REG_FAVOR%" EQU "y" (
  set "REG_FAVOR=Y"
)

if /I "%REG_FAVOR%" EQU "Y" (
  REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites ^
    /v "SPC" /t REG_SZ /d "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC" /f
)

REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC\Certificates >nul 2>&1

if %ERRORLEVEL% EQU 0 (
  if /I "%REG_CHANGE%" EQU "Y" (
    REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC\Certificates /f
  ) else (
    echo Registry modification is needed to complete the process!
  )
) else (
  echo Modification is already done!
)

timeout 100
