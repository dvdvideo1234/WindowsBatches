@echo off

setlocal EnableDelayedExpansion

:: Manual
set "framesOut=out_f"
set "framesWait=N"

:: Automatic ( Dont touch )
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

if not exist !framesFold! mkdir !framesFold!

for /F "delims=" %%a in ('dir "!framesBase!\*.*" /b /s') do (
  set "var=%%a"
  call :frameGetExtension !var!
  call :framesGetFile !var!
  call copy /v /y "!var!" "!framesFile!" >nul
  call convert.bat !framesFile! !framesConv! !framesWait! >nul && (
    echo Success: !var!
  ) || (
    echo Abort convert: [!var!]^^!
    exit /B 1
  )
  call copy /v /y "!framesOut!!framesExt!" "!framesFold!\!framesFile!" >nul || (
    echo Abort extract: [!var!]^^!
    exit /B 2
  )
  call del "!framesFile!" >nul
)

call del out*.* >nul

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
