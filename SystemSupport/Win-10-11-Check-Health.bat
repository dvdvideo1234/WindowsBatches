@echo off

echo Restoring system health...

call DISM /Online /Cleanup-Image /CheckHealth

call DISM /Online /Cleanup-Image /ScanHealth

call DISM /Online /Cleanup-image /Restorehealth

call sfc /scannow

timeout 300

exit 0
