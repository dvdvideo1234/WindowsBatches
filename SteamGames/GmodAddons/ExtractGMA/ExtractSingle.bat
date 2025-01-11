@echo off

setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set "gma_ext_path=%~dp0"
set "gma_ext_file=%1"
set "gma_ext_dirf=%~n1"
set "gma_ext_inpu=%~x1"

echo INPEXT: [!gma_ext_inpu!]
echo FILNAM: [!gma_ext_dirf!]
echo BINDIR: [%GMOD_HOME%\bin]
echo OUTPUT: [!gma_ext_path!OUTPUT]
echo INPUTS: [!gma_ext_file!]

if /I "%gma_ext_inpu%" EQU ".bin" (
  echo Binary extension... [!gma_ext_dirf!.bin]
  if exist "!gma_ext_dirf!" del "!gma_ext_dirf!"
  if exist "!gma_ext_dirf!.gma" del "!gma_ext_dirf!.gma"
  call %ZIP7_HOME%\7z.exe e -bso0 -bse0 -bsp0 "!gma_ext_file!"
  echo Extract contents... [!gma_ext_dirf!.gma]
  ren "!gma_ext_dirf!" "!gma_ext_dirf!.gma"
  set "gma_ext_file=!gma_ext_path!!gma_ext_dirf!.gma"
)

if not exist "!gma_ext_path!OUTPUT" mkdir "!gma_ext_path!OUTPUT"

echo Extracting...

call "!gma_ext_path!.src\Processor" %GMOD_HOME%\bin "!gma_ext_file!" "!gma_ext_path!OUTPUT"

if /I "%gma_ext_inpu%" EQU ".bin" (
  echo Binary extension clear [!gma_ext_dirf!.bin]
  if exist "!gma_ext_dirf!" del "!gma_ext_dirf!"
  if exist "!gma_ext_dirf!.gma" del "!gma_ext_dirf!.gma"
)

echo Done...

timeout 1000

