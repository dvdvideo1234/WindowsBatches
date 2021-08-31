@echo off

setlocal EnableDelayedExpansion



:: Automatic ( Dont touch )
set "framesCurr=%~dp0"
set "framesBase=%1"
set /a "framesConv=%2"
call :framesGetFolder !framesCurr!
del *.log

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
  call :frameGetExtension !var!
  call :framesGetName !var!
  call :framesGetFile !var!
  set "src=out_f!framesExt!"
  set "des=!framesCurr!!framesFold!\!framesFile!"
  call copy /v /y "!var!" "!framesName!.jpg"
  call convert.bat !framesName!.jpg !framesConv! N
  call copy /v /y "out_f.jpg" "!framesFold!\!framesName!.jpg"
  del "!framesName!.jpg"
)

del out*.jpg

:: Functions

goto :eof

:frameGetExtension
set "framesExt=%~x1"

goto :eof

:framesGetName
set "framesName=%~n1"

goto :eof

:framesGetFile
set "framesFile=%~nx1"

goto :eof

:framesGetFolder
set "framesFold=%~n0"

goto :eof
