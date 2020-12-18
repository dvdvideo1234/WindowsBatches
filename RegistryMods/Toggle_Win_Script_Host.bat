@echo off

setlocal EnableDelayedExpansion

set "OS_VERSION=Microsoft"
set "OS_STATE=1"

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

:: Provide a value for the registry

set /p REG_CHANGE="Enable WScript Host [y/N] ? "

if /I "!REG_CHANGE!" EQU "y" (
  set "REG_CHANGE=Y"
)

if /I "!REG_CHANGE!" EQU "Y" (
  set "OS_STATE=1"
) else (
  set /p REG_CHANGE="Delete the setting [y/N] ? "

  if /I "!REG_CHANGE!" EQU "y" (
    set "REG_CHANGE=Y"
  )

  if /I "!REG_CHANGE!" EQU "Y" (
    set "OS_STATE=X"
  ) else (
    set "OS_STATE=0"
  )
)

:: Write the value set ON

set /p REG_CHANGE="Apply registry changes [y/N] ? "

if /I "!REG_CHANGE!" EQU "y" (
  set "REG_CHANGE=Y"
)

if /I "!REG_CHANGE!" EQU "Y" (
  if /I "!OS_STATE!" EQU "X" (
    REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Script Host\Settings" /f /v "Enabled"
    REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Script Host\Settings" /f /v "Enabled"
  ) else (
    REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Script Host\Settings" /f /v "Enabled" /t REG_DWORD /d "!OS_STATE!"
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Script Host\Settings" /f /v "Enabled" /t REG_DWORD /d "!OS_STATE!"
  )
) else (
  echo Registry modification was skipped!
  for /F "usebackq tokens=3" %%i in (`REG QUERY "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled`) do (
    echo Current user: %%i
  )
  for /F "usebackq tokens=3" %%i in (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled`) do (
    echo Current machine: %%i
  )  
)

timeout 100

exit 0 
