@echo off

setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set gma_ext_path=%~dp0
set gma_ext_file=%1
set gma_ext_dirf=%~n1

echo FOLDER: [!gma_ext_dirf!]
echo BINDIR: [%GMOD_HOME%\bin]
echo OUTPUT: [!gma_ext_path!OUTPUT]
echo INPUTS: [!gma_ext_file!]

if not exist "!gma_ext_path!OUTPUT" mkdir "!gma_ext_path!OUTPUT"

echo Extracting...

call "!gma_ext_path!.src\Processor" %GMOD_HOME%\bin "!gma_ext_file!" "!gma_ext_path!OUTPUT"

echo Done...

timeout 100

