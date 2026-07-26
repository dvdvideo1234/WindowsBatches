@echo off

set "DISM_BOOL="

echo Restoring system health...

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-Image /CheckHealth

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-Image /ScanHealth

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-image /Restorehealth

call %SystemRoot%\system32\Dism.exe /Online /Cleanup-Image /StartComponentCleanup

call %SystemRoot%\system32\sfc.exe /scannow

call %SystemRoot%\system32\sfc.exe /scannow

call %SystemRoot%\system32\verifier.exe

call %SystemRoot%\system32\sigverif.exe

call %SystemRoot%\system32\dxdiag.exe

:: Update or unstall WSL
set /p "DISM_BOOL=Deep volume check [y/N]: "
if /I "%DISM_BOOL%" EQU "y" (
  set "DISM_BOOL=Y"
)

if /I "%DISM_BOOL%" EQU "Y" (
  call %SystemRoot%\system32\chkdsk.exe /F /V /R C:
) else (
  call %SystemRoot%\system32\chkdsk.exe /I /C C:
)

timeout 300

exit 0
