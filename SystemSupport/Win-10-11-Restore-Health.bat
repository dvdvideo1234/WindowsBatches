@echo off

echo Restoring system health...

call DISM /Online /Cleanup-Image /CheckHealth

call DISM /Online /Cleanup-Image /ScanHealth

call DISM /Online /Cleanup-image /Restorehealth

call sfc /scannow

call sfc /scannow

call sfc /scannow

call chkdsk /F /V /R C:

timeout 300

exit 0
