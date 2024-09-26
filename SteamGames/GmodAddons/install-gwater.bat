@Echo OFF

SetLocal EnableDelayedExpansion

set "SteamAppURL=https://github.com/meetric1/GWater-V3/releases/download/1.4/GWater_Modules.zip"
set "SteamAppPWD=%~dp0"
set "SteamAppExe=!GMOD_HOME!"
set "SteamAppPth="

for /F "Tokens=1,2*" %%A in ('reg query HKCU\SOFTWARE\Valve\Steam') do (
    If "%%A" equ "SteamPath" set "SteamAppPth=%%C")

set "SteamAppPth=!SteamAppPth:/=\!"

if "!SteamAppExe!" equ "" (
  set "SteamAppTmp="
  echo Extracting GMOD_HOME from libraries...
  echo Using: !SteamAppPth!\steamapps\libraryfolders.vdf
  cd /d "!SteamAppPth!\steamapps\"
  for /F "tokens=1,2 delims=" %%i in (libraryfolders.vdf) do (
    echo.%%i | FINDSTR /I "path">Nul && (
      set "SteamAppTmp=%%i"
    )
    echo.%%i | FINDSTR /I "4000">Nul && (
      set "SteamAppExe=!SteamAppTmp!"
      set "SteamAppExe=!SteamAppExe:path=!"
      set "SteamAppExe=!SteamAppExe:"=!"
      set "SteamAppExe=!SteamAppExe:\\=\!"
      for /f "usebackq tokens=*" %%a in (`echo !SteamAppExe!`) do set SteamAppExe=%%a
      set "SteamAppExe=!SteamAppExe!\steamapps\common\GarrysMod"
    )
  )
  cd /d "!SteamAppPWD!"
)

if exist "module.zip" (
  echo Clearing archive...
  call del .\module.zip
)

if exist "module" (
  echo Clearing contents...
  rmdir /s /q module
)

if exist "*.dll" (
  echo Clearing DLLs...
  call del *.dll
)

if not exist "!SteamAppExe!" (
  echo Game main directory does not exist...
  goto :EOF
)

echo Detected PWD: !SteamAppPth!
echo Detected GMD: !SteamAppExe!

timeout 100

call powershell.exe Invoke-WebRequest !SteamAppURL! -OutFile .\module.zip

call powershell.exe Expand-Archive -Force .\module.zip module

call powershell.exe Move-Item -Force -Path module\gmcl_*.dll -Destination .

call cd /d "!SteamAppExe!\garrysmod"

if not exist "lua" call mkdir lua

if not exist "lua\bin" call mkdir lua\bin

cd /d "!SteamAppPWD!"

call powershell.exe Move-Item -Force -Path "gmcl_*.dll" -Destination "!SteamAppExe!\garrysmod\lua\bin"

call powershell.exe Move-Item -Force -Path "module\*.dll" -Destination "!SteamAppExe!"

:EOF
