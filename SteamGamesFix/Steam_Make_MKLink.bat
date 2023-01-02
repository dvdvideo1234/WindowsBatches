@echo off

set "SteamAppPWD=%~dp0"
set "SteamAppExe="
set "SteamAppPth="

for /F "Tokens=1,2*" %%A in ('reg query HKCU\SOFTWARE\Valve\Steam') do (
    If "%%A" equ "SteamExe" set "SteamAppExe=%%C"
    If "%%A" equ "SteamPath" set "SteamAppPth=%%C")

echo Steam MKLink created for %SteamAppPth%

:: cd "<GameFolder>”
:: mklink "steam.exe" "<SteamFolder>\steam.exe"

cd /d "%SteamAppPWD%"
mklink "steam.exe" "%SteamAppExe%"
