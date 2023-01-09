@echo off

set "WSL_WSL_OS_BUILD="
set "WSL_WSL_OS_VERSN="

for /F "usebackq tokens=4" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) do (
  set "WSL_OS_VERSN=%%i"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) do (
  set "WSL_OS_BUILD=%%i"
)

net session >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Run the script as administrator to apply the registry changes!
  goto end-script
)

if %WSL_OS_VERSN% NEQ 10 (
  echo WSL is suppoerted on Windows 10 and above!
  goto end-script
)

call dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
call dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
call Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

call wsl.exe --install

call wsl.exe --list --online

set /p "WSL_OS_DESTRO=Destribution: "

if %WSL_OS_BUILD% GEQ 18917 (
  echo WSL version is 2.0!
  set "WSL_VERSN=2"
) else (
  echo WSL version is 1.0!
  set "WSL_VERSN=1"
)

call wsl --install -d %WSL_VERSN%
call wsl.exe --set-default-version %WSL_VERSN%
call wsl.exe --set-version %WSL_OS_DESTRO% %WSL_VERSN%

:end-script

timeout 100
