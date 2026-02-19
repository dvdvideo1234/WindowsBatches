@echo off

echo Restoring system health...

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-Image /CheckHealth

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-Image /ScanHealth

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-image /Restorehealth

call %SystemRoot%\system32\sfc.exe /scannow

call %SystemRoot%\system32\sfc.exe /scannow

call %SystemRoot%\system32\sfc.exe /scannow

call %SystemRoot%\system32\verifier.exe

call %SystemRoot%\system32\sigverif.exe

call %SystemRoot%\system32\dxdiag.exe

call %SystemRoot%\system32\chkdsk.exe /F /V /R C:

timeout 300

exit 0
