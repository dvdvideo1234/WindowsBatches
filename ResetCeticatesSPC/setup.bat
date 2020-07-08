@echo off

set "OS_VERSION=Microsoft"

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) DO (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CSDVersion`) DO (
  set "OS_VERSION=%OS_VERSION% %%i %%j %%k"
)

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentVersion`) DO (
  set "OS_VERSION=%OS_VERSION% %%i"
)

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) DO (
  set "OS_VERSION=%OS_VERSION% %%i"
)

FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v CSDBuildNumber`) DO (
  set "OS_VERSION=%OS_VERSION% %%i"
)

echo %OS_VERSION%

REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\SPC\Certificates /f

timeout 100

exit 0
