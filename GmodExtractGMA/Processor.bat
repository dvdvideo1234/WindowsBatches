@echo off

rem rd /S /Q %~f3\%~n2

echo Delete: %~f3\%~n2 >> "%~f3\process.log"

call %~f1/gmad.exe extract -file "%~f2" -out "%~f3\%~n2"
echo > %~f3\%~n2\addon.txt
