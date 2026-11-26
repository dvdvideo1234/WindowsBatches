@echo off

setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set "gma_ext_path=%~dp0"
set "gma_ext_file=%1"
set "gma_ext_name=%~n1"
set "gma_ext_inpu=%~x1"

if "!gma_ext_file:\=!"=="!gma_ext_file!" (
 set "gma_ext_file=!gma_ext_path!!gma_ext_file!"
 echo Expanding file ["!gma_ext_file!"]
)

echo INPEXT: [!gma_ext_inpu!]
echo FILNAM: [!gma_ext_name!]
echo BINDIR: [%GMOD_HOME%\bin]
echo OUTPUT: [!gma_ext_path!OUTPUT]
echo INPUTS: [!gma_ext_file!]

if not exist "!gma_ext_path!OUTPUT" mkdir "!gma_ext_path!OUTPUT"

if /I "%gma_ext_inpu%" EQU ".bin" (
  echo Binary extension... [!gma_ext_name!.bin]
  cd "!gma_ext_path!OUTPUT"
  if exist "!gma_ext_name!" rmdir /s /q "!gma_ext_name!"
  if not exist "!gma_ext_name!" mkdir "!gma_ext_name!"
  cd "!gma_ext_name!
  call %ZIP7_HOME%\7z.exe e -bso0 -bse0 -bsp0 "!gma_ext_file!"
  for %%F in ("*!gma_ext_name!*") do (
    if /i not "%%~nxF"=="!gma_ext_name!.gma" (
        ren "%%~fF" "!gma_ext_name!.gma"
        echo Renamed ["%%~fF"] to ["!gma_ext_name!.gma"]
    )
  )
) else if /I "%gma_ext_inpu%" EQU ".gma" (
  echo Gmad extension... [!gma_ext_name!.gma]
  cd "!gma_ext_path!OUTPUT"
  if exist "!gma_ext_name!" rmdir /s /q "!gma_ext_name!"
  if not exist "!gma_ext_name!" mkdir "!gma_ext_name!"
  call copy /v /y "!gma_ext_file!" "!gma_ext_path!OUTPUT\!gma_ext_name!"
) else (
  echo Unsupported extension... [!gma_ext_inpu!]
  timeout 1000
  exit 0
)

echo Extracting... ["!gma_ext_path!OUTPUT\!gma_ext_name!\!gma_ext_name!.gma"]

call "!gma_ext_path!..\.src\Processor"^
  %GMOD_HOME%\bin^
  "!gma_ext_path!OUTPUT\!gma_ext_name!\!gma_ext_name!.gma"^
  "!gma_ext_path!OUTPUT\!gma_ext_name!"^
  "!gma_ext_path!OUTPUT\!gma_ext_name!\extract.txt"^

echo Done...

timeout 1000

