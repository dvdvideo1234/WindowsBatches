@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

:: The user configures the following

set "SrcPath=%1"
set OnlyAddons=()
set SkipAddons=()

:: The rest of the file is automatic

set /a "FileCount=0"
set /a "CurrCount=0"
set /a "PrComplete=0"
set "FileExt=gma"
set "CurPath=%~dp0"
set "OnlyAddonsCount=0"
set "SkipAddonsCount=0"
set "StartTime=%date% %time%"
set "BinPath=%GMOD_HOME%\bin"

:: Destination path
set "OutPath=%CurPath%\OUTPUT"

:: Log file path
set "LogPath=%OutPath%\process.log"

if "%SrcPath%" EQU "" (
  set "SrcPath=%GMOD_HOME%\garrysmod\addons"
  echo Source path empty^^!
  echo Default to: !SrcPath!
)

for /f %%i in ('call .src\Count.bat "!SrcPath!" !FileExt!') do set FileCount=%%i

echo Total [*.!FileExt!] files found: !FileCount!^^!

del /f /q %LogPath%

echo Processing addons has started^^! >> %LogPath%

for /F "delims=" %%a in (only.txt) do (
   set /A "OnlyAddonsCount=!OnlyAddonsCount! + 1"
   set OnlyAddons[!OnlyAddonsCount!]=%%a
   echo ONLY: %%a
)

echo ONLY: %OnlyAddonsCount%

for /F "delims=" %%a in (skip.txt) do (
   set /A "SkipAddonsCount=!SkipAddonsCount! + 1"
   set SkipAddons[!SkipAddonsCount!]=%%a
   echo SKIP: %%a
)

echo SKIP: %SkipAddonsCount%

echo GBIN: %BinPath% >> %LogPath%
echo SORS: %SrcPath% >> %LogPath%

echo CHECK: dir !SrcPath!\*.!FileExt! /b /s >> %LogPath%

echo Press ENTER to continue with the extraction^^!

timeout 100

for /F "delims==" %%k in ('dir !SrcPath!\*.!FileExt! /b /s') do (
  call .src\Increment.bat !CurrCount! CurrCount
  call .src\Percent.bat !CurrCount! !FileCount! PrComplete
  
  echo ADDON [!CurrCount! of !FileCount!][!PrComplete!]: %%~nxk
  
  set /A SkipAddonsMatch=0
  if !SkipAddonsCount! GTR 0 (
    for /L %%j in (1,1,!SkipAddonsCount!) do (
      call .src\Contain.bat "%%k" "!SkipAddons[%%j]!"
      echo K: %%k >> !LogPath!
      echo J: !SkipAddons[%%j]! >> !LogPath!
      echo E: !ERRORLEVEL! >> !LogPath!
      
      if !ERRORLEVEL! EQU 1 (
        echo ADDON SKIP: %%k >> !LogPath!
        set /A SkipAddonsMatch=!SkipAddonsMatch!+1
      )
    )
  )

  if !OnlyAddonsCount! GTR 0 (
    for /L %%i in (1,1,!OnlyAddonsCount!) do (
      call .src\Contain.bat "%%k" "!OnlyAddons[%%i]!"
      echo K: %%k >> !LogPath!
      echo I: !OnlyAddons[%%i]! >> !LogPath!
      echo E: !ERRORLEVEL! >> !LogPath!
      
      if !ERRORLEVEL! EQU 1 (
        if !SkipAddonsMatch! EQU 0 (
          echo ADDON ONLY: %%k >> !LogPath!
          call .src\Processor !BinPath! %%k !OutPath!
        )
      )
    )
  ) else (
    if !SkipAddonsMatch! EQU 0 (
      echo ADDON DIRE: %%k >> !LogPath!
      call .src\Processor !BinPath! %%k !OutPath!
    )
  )
)

timeout 100

echo TBEGIN: %StartTime% >> %LogPath%
echo FINISH: %date% %time% >> %LogPath%
