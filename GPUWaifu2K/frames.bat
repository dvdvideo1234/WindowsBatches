@echo off

setlocal EnableDelayedExpansion

:: Manual
set "framesOut=out_f"
set "framesExt=.jpg"
set "framesWait=N"

:: Automatic ( Dont touch )
set "framesLogs=frames.log"
set "framesCurr=%~dp0"
set "framesBase=%1"
set "framesConv=%2"
call :framesGetFolder !framesBase!
call del *.log >nul

echo.
echo Sors: "!framesCurr!!framesBase!"
echo Dest: "!framesCurr!!framesFold!"

if /I "!framesBase!" EQU "" (
  echo Source folder missing^^!
  goto :eof
)

if not defined framesConv (
  echo Undefined using [1]^^!
  set /a "framesConv=1"
)

echo Conversion stage [!framesConv!]^^!

if /I !framesConv! LEQ 0 (
  echo Mismatch using [1]^^!
  set /a "framesConv=1"
) else (
  echo Arithmetic using [!framesConv!]^^!
  set /a "framesConv=!framesConv!"
)

timeout 45

echo Process has started [%DATE% %TIME%]>>%framesLogs%

if not exist !framesFold! mkdir !framesFold!

for /F "delims=" %%a in ('dir "!framesBase!\*.*" /b /s') do (
  set "var=%%a"
  call :framesGetFile !var!
  echo Prepare sors: !var!>>%framesLogs%
  echo Prepare dest: !framesFile!>>%framesLogs%
  call copy /v /y "!var!" "!framesFile!">>%framesLogs%
  call convert.bat !framesFile! !framesConv! !framesWait! >nul && (
    echo Convert success: !var!
  ) || (
    echo Failure: [!var!]^^!
    exit /B 1
  )
  call :frameGetName !framesFile!
  call :frameGetExtension !framesOut!!framesExt!
  echo Store sors: !framesOut!!framesExt!>>%framesLogs%
  echo Store dest: !framesFold!\!framesName!!framesExt!>>%framesLogs%
  call copy /v /y "!framesOut!!framesExt!" "!framesFold!\!framesName!!framesExt!">>%framesLogs% || (
    echo Store failure: [!var!]^^!
    exit /B 2
  )
  call del "!framesFile!">>%framesLogs%
)

call del out*.* >nul

echo Process has ended [%DATE% %TIME%]>>%framesLogs%

:: Functions

goto :eof

:frameGetName
set "framesName=%~n1"

goto :eof

:frameGetExtension
set "framesExt=%~x1"

goto :eof

:framesGetFile
set "framesFile=%~nx1"

goto :eof

:framesGetFolder
set "framesFold=%~n1_out"

goto :eof
