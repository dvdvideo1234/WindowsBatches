@echo off
del %~f3\%~n2
call %~f1/gmad.exe extract -file "%~f2" -out "%~f3\%~n2"
echo > %~f3\%~n2\addon.txt