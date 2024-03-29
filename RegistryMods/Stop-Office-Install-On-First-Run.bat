@echo off

echo %OS_VERSION%
echo Please run the script as administrator to apply the registry changes!

set /p REG_CHANGE="Apply registry changes [y/N] ? "

if /I "%REG_CHANGE%" EQU "y" (
  set "REG_CHANGE=Y"
)

if /I "%REG_CHANGE%" EQU "Y" (
  REG ADD HKCU\Software\Microsoft\Office\14.0\Word\Options /v NoReReg /t REG_DWORD /d 1
) else (
  echo Registry modification is needed to complete the process!
)

timeout 100

exit 0
