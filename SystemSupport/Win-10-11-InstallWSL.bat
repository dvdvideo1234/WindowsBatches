@echo off

set "WSL_BUILD="
set "WSL_VERSN="

for /F "usebackq tokens=4" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) do (
  set "WSL_VERSN=%%i"
)

for /F "usebackq tokens=3" %%i in (`REG QUERY "hklm\software\microsoft\windows NT\CurrentVersion" /v CurrentBuild`) do (
  set "WSL_BUILD=%%i"
)

net session >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Run the script as administrator to apply the registry changes!
  goto end-script
)

if %WSL_VERSN% NEQ 10 (
  echo WSL is suppoerted on Windows 10 and above!
  goto end-script
)

sc \\%ComputerName% query vmms >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Hyper-V is a requirement for WSL sub-systems!
  goto end-script
)

:: Update or unstall WSL
set /p "WSL_UPDATE=Update destribution [y/N]: "
if /I "%WSL_UPDATE%" EQU "y" (
  set "WSL_UPDATE=Y"
)

if /I "%WSL_UPDATE%" EQU "Y" (
  :: List of available
  wsl --list --ver
  :: Pick destribution
  set /p "WSL_DESTRO=Destribution: "
  :: Read WSL version
  if %WSL_BUILD% GEQ 18917 (
    echo WSL version is 2.0!
    set "WSL_VERSN=2"
  ) else (
    echo WSL version is 1.0!
    set "WSL_VERSN=1"
  )
  :: Convert the WSL
  call wsl.exe --set-version %WSL_DESTRO% %WSL_VERSN%
) else (
  :: Install stuff
  call dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  call dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
  call Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
  :: Install WSL
  call wsl.exe --install --no-distribution
  :: List available
  call wsl.exe --list --online
  :: Pick destribution
  set /p "WSL_DESTRO=Destribution: "
  :: Read WSL version
  if %WSL_BUILD% GEQ 18917 (
    echo WSL version is 2.0!
    set "WSL_VERSN=2"
  ) else (
    echo WSL version is 1.0!
    set "WSL_VERSN=1"
  )
  :: Install destribution
  echo Installing [%WSL_DESTRO%]^^!
  call wsl --install -d %WSL_DESTRO%
  :: Apply destribution WSL
  echo Configuring WSL version [%WSL_VERSN%]^^!
  call wsl.exe --set-default-version %WSL_VERSN%
)

:end-script

timeout 100
