@echo off
rd /S /Q %~f3\%~n2
call %~f1/gmad.exe extract -file "%~f2" -out "%~f3\%~n2" >> "%~f3\processor.log"
echo > %~f3\%~n2\addon.txt
