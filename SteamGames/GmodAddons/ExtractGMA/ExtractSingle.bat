@echo off
setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set gma_ext_path=%~dp0
set gma_ext_file=%1
set gma_ext_dirf=%~n1
echo Output: [!gma_ext_path!]
echo Input : [!gma_ext_file!]
echo Folder: [!gma_ext_dirf!]

rd /S /Q "!gma_ext_path!!gma_ext_dirf!"

mkdir "!gma_ext_path!!gma_ext_dirf!"

echo Extracting...

call %GMOD_HOME%\bin\gmad.exe extract -file "!gma_ext_file!" -out "!gma_ext_path!!gma_ext_dirf!"

timeout 10
