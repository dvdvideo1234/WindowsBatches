@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

:: The user configures the following

::set "SrcPath=%1"
set "SrcPath=I:\SteamLibrary\steamapps\workshop\content\4000"

set OnlyAddons=()
set SkipAddons=()

:: The rest of the file is automatic

set "BinPath="
set /a "FileCount=0"
set /a "CurrCount=0"
set /a "PrComplete=0"
set "FileExt=gma"
set "CurPath=%~dp0"
set "OnlyAddonsCount=0"
set "SkipAddonsCount=0"
set "StartTime=%date% %time%"

:: Game BIN path
call .src\GamePath.bat BinPath

:: Destination path
set "OutPath=%CurPath%\OUTPUT"
if not exist %OutPath% mkdir %OutPath%

:: Log file path
set "LogPath=%CurPath%\process.log"

if "%SrcPath%" EQU "" (
  set "SrcPath=%GMOD_HOME%\garrysmod\addons"
  echo Source path empty^^!
  echo Default to: !SrcPath!
)

for /f %%i in ('call .src\Count.bat "!SrcPath!" !FileExt!') do set FileCount=%%i

echo Total [*.!FileExt!] files found: !FileCount!^^!

echo BASE: !CurPath!
echo GBIN: !BinPath!
echo SORS: !SrcPath!

echo BASE: %CurPath% >> %LogPath%
echo GBIN: %BinPath% >> %LogPath%
echo SORS: %SrcPath% >> %LogPath%

echo Press ENTER to continue with the extraction^^!

timeout 100

echo Processing addons has started^^! >> %LogPath%

for /F "delims==" %%k in ('dir !SrcPath!\*.!FileExt! /b /s') do (
  call .src\Increment.bat !CurrCount! CurrCount
  call .src\Percent.bat !CurrCount! !FileCount! PrComplete
  
  echo ADDON [!CurrCount! of !FileCount!][!PrComplete!]: %%~nxk
  echo ADDON [!CurrCount! of !FileCount!][!PrComplete!]: %%~nxk >> %LogPath%
  
  call .src\Processor !BinPath! %%k !OutPath! !LogPath!
)

echo TBEGIN: %StartTime% >> %LogPath%
echo FINISH: %date% %time% >> %LogPath%

timeout 100
