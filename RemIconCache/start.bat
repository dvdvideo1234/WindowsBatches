@echo off

echo Windows keeps icons cache to APPDATA!
echo Use this when you have blank sheet icons in the taskbar!
echo Restart the PC after the modification!

set /p ICON_CHOISE="Apply changes [y/N] ? "

if /I "%ICON_CHOISE%" EQU "y" (
  set "ICON_CHOISE=Y"
)

if /I "%ICON_CHOISE%" EQU "Y" (
  cd /d %appdata%\..\Local
  del IconCache.db
) else (
  echo Icon cache deletion skipped!
)
