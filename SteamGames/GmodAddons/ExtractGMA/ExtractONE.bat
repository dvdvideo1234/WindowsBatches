@echo off

setlocal enabledelayedexpansion

rem The location of the script ( Do not change )
set "gma_ext_path=%~dp0"
set "gma_ext_file=%1"
set "gma_ext_name=%~n1"
set "gma_ext_inpu=%~x1"
set "gma_ext_rgma=%2"
set "gma_ext_nech=%3"
set "gma_ext_logs=%4"

if "!gma_ext_nech!" EQU "y" (
  set "gma_ext_nech=Y"
)

if /i "!gma_ext_nech!" EQU "Y" (
    set "gma_ext_nech= >nul 2>&1"
) else (
    set "gma_ext_nech="
)

rem Game BIN path
if /i "%GMOD_HOME%" EQU "" (
  call ..\.src\GamePath.bat gma_ext_base
) else (
  set "gma_ext_base=%GMOD_HOME%"
)

if "!gma_ext_file:\=!"=="!gma_ext_file!" (
 set "gma_ext_file=!gma_ext_path!!gma_ext_file!"
 echo Expanding file ["!gma_ext_file!"]%gma_ext_nech%
)

echo INPEXT: [!gma_ext_inpu!]%gma_ext_nech%
echo FILNAM: [!gma_ext_name!]%gma_ext_nech%
echo BINDIR: [%GMOD_HOME%\bin]%gma_ext_nech%
echo OUTPUT: [!gma_ext_path!OUTPUT]%gma_ext_nech%
echo INPUTS: [!gma_ext_file!]%gma_ext_nech%

if not exist "!gma_ext_path!OUTPUT" mkdir "!gma_ext_path!OUTPUT"

if /I "%gma_ext_inpu%" EQU ".bin" (
  echo Binary extension... [!gma_ext_name!.bin]%gma_ext_nech%
  cd "!gma_ext_path!OUTPUT"
  if exist "!gma_ext_name!" rmdir /s /q "!gma_ext_name!"
  if not exist "!gma_ext_name!" mkdir "!gma_ext_name!"
  cd "!gma_ext_name!
  call %ZIP7_HOME%\7z.exe e -bso0 -bse0 -bsp0 "!gma_ext_file!"
  for %%F in ("*!gma_ext_name!*") do (
    if /i not "%%~nxF"=="!gma_ext_name!.gma" (
        ren "%%~fF" "!gma_ext_name!.gma"
        echo Renamed ["%%~fF"] to ["!gma_ext_name!.gma"]%gma_ext_nech%
    )
  )
) else if /I "%gma_ext_inpu%" EQU ".gma" (
  echo Gmad extension... [!gma_ext_name!.gma]%gma_ext_nech%
  cd "!gma_ext_path!OUTPUT"
  if exist "!gma_ext_name!" rmdir /s /q "!gma_ext_name!"
  if not exist "!gma_ext_name!" mkdir "!gma_ext_name!"
  call copy /v /y "!gma_ext_file!" "!gma_ext_path!OUTPUT\!gma_ext_name!"%gma_ext_nech%
) else (
  echo Unsupported extension... [!gma_ext_inpu!]%gma_ext_nech%
  if "!gma_ext_nech!" EQU "" (
    timeout 1000
  )
  exit 0
)

if "!gma_ext_logs!" EQU "" (
  set "gma_ext_logs=!gma_ext_path!OUTPUT\!gma_ext_name!\extract.txt"
)

echo Extracting... ["!gma_ext_path!OUTPUT\!gma_ext_name!\!gma_ext_name!.gma"]%gma_ext_nech%

call "!gma_ext_path!..\.src\Processor"^
  "!gma_ext_base!\bin"^
  "!gma_ext_path!OUTPUT\!gma_ext_name!\!gma_ext_name!.gma"^
  "!gma_ext_path!OUTPUT\!gma_ext_name!"^
  "!gma_ext_logs!"^

rem Force delete the destination GMA
if "!gma_ext_rgma!" EQU "y" (
  set "gma_ext_rgma=Y"
)

if "!gma_ext_rgma!" EQU "Y" (
  del /f /q "!gma_ext_path!OUTPUT\!gma_ext_name!\!gma_ext_name!.gma"
)

echo Done...%gma_ext_nech%

if "!gma_ext_nech!" EQU "" (
  timeout 1000
)

