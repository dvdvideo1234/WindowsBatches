@echo off

echo Restoring system health...

call %SystemRoot%\system32\verifier.exe /reset

call %SystemRoot%\system32\verifier.exe /bootmode resetonbootfail

timeout 300

exit 0
