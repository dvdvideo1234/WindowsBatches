@echo off

set "RUNMODE=%1"
set "RUNPROG=%2"
set "RUNPATH=%3"

:: Win-10-11-RunWhenMissing.bat tasklist caffeine64.exe "C:\Programs\Caffeine\caffeine64.exe"

:: Check if the process is running and capture the output
if "%RUNMODE%" EQU "tasklist" (
  tasklist /FI "IMAGENAME eq %RUNPROG%" /FO LIST 2>NUL | find /I "%RUNPROG%" >NUL
  if %ERRORLEVEL% EQU 0 (
    echo The process [%RUNMODE%] %RUNPROG% is running.
  ) else (
    echo The process [%RUNMODE%] %RUNPROG% is not running. Starting...
    start "" "%RUNPATH%"
  )
)

if "%RUNMODE%" EQU "wmic" (
  wmic process list brief 2>NUL | find /i "%RUNPROG%" >NUL
  if %ERRORLEVEL% EQU 0 (
    echo The process [%RUNMODE%] %RUNPROG% is running.
  ) else (
    echo The process [%RUNMODE%] %RUNPROG% is not running. Starting...
    start "" "%RUNPATH%"
  )
)
