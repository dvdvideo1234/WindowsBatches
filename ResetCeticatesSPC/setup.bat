@echo off

set "OS_VERSION=Microsoft"

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) DO (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CSDVersion`) DO (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

FOR /F "usebackq tokens=3" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentVersion`) DO (
  set "OS_VERSION=%OS_VERSION% %%i"
)

FOR /F "usebackq tokens=3" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) DO (
  set "OS_VERSION=%OS_VERSION%.%%i"
)

FOR /F "usebackq tokens=3" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CSDBuildNumber`) DO (
  set "OS_VERSION=%OS_VERSION% [%%i]"
)

echo %OS_VERSION%
echo Please run the script as administrator to apply the registry changes!

set /p REG_CHANGE="Apply registry changes [y/N] ? "

if /I "%REG_CHANGE%" EQU "y" (
  set "REG_CHANGE=Y"
)

if /I "%REG_CHANGE%" EQU "Y" (
  REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC\Certificates /f
) else (
  echo Registry modification is needed to complete the process!
)

timeout 100

exit 0
