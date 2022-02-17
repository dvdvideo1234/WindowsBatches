@echo off

setlocal EnableDelayedExpansion

:: Manual
set "framesOut=out_f"
set "framesWait=N"

:: Automatic ( Dont touch )
set "framesCurr=%~dp0"
set "framesBase=%1"
set /a "framesConv=%2"
call :framesGetFolder !framesBase!
del *.log >nul

echo.
echo Sors: "!framesCurr!!framesBase!"
echo Dest: "!framesCurr!!framesFold!"
timeout 100

if /I "!framesBase!" EQU "" (
  echo Source folder missing^^!
  goto :eof
)

if not defined framesConv (
  echo Conversion stage [!framesConv!]^^!
  set /a "framesConv=1"
  echo Not defined using [1] instead^^!
)

if /I "!framesConv!" LEQ "0" (
  echo Conversion stage [!framesConv!]^^!
  set /a "framesConv=1"
  echo Mismatch using [1] instead^^!
)

if not exist !framesFold! mkdir !framesFold!

for /F "delims=" %%a in ('dir "!framesBase!\*.*" /b /s') do (
  set "var=%%a"
  echo !var!
  call :frameGetExtension !var!
  call :framesGetFile !var!
  call copy /v /y "!var!" "!framesFile!" >nul
  call convert.bat !framesFile! !framesConv! !framesWait! >nul
  call copy /v /y "!framesOut!!framesExt!" "!framesFold!\!framesFile!" >nul
  call del "!framesFile!" >nul
)

del out*.*

:: Functions

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
