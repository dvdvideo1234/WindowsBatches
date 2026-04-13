@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

set "gmodBinPath="
set "gmodLibPath="
set "gmodSteamPath="
set "gmodAppPath=steamapps\common\GarrysMod"
set "gmodSteamPID=HKCU\Software\Valve\Steam\ActiveProcess"

if not defined gmadBinPath (
  set "gmadLibPath=!gmadRevPath!"

  echo Searching for game binary via addon^^!

  for /L %%I in (1, 1, 4) do (

    :: Swap the slashes for windows
    set "gmodLibPath=!gmodLibPath:/=\!"

    :: Replace double slashes with single slashes
    set "gmodLibPath=!gmodLibPath:\\=\%!

    :: Remove the last slash when present
    if !gmodLibPath:~-1!==\ set gmodLibPath=!gmodLibPath:~0,-1!

    :: Trim the leading and the trailing spaces
    for /f "tokens=*" %%Z in ("!gmodLibPath!") do set gmodLibPath=%%~dpnxZ
    set gmodLibPath=!gmodLibPath!

    :: They the current addon path
    if exist "!gmodLibPath!\gmod.exe" (
      echo [V] Binary addon: !gmodLibPath!
      set "gmodBinPath=!gmodLibPath!\bin"
      goto :BIN_ADDON
    ) else (
      echo [X] Binary addon: !gmodLibPath!
    )

    :: Remove `/<ADDON_FOLDER>`
    for %%A in ("!gmodLibPath!") do set gmodLibPath=%%~dpA
  )
)

:BIN_ADDON

if not defined gmodBinPath (
  echo Searching for game binary via library^^!

  :: Retrieve steam DLL install location
  for /F "Tokens=1,2*" %%A in ('reg query !gmodSteamPID!') do (
    If "%%A" equ "SteamClientDll" set "gmodSteamPath=%%C")
  
  echo Steam path: !gmodSteamPath!
  
  :: Replace slashes for windows
  set "gmodSteamPath=!gmodSteamPath:/=\!"

  :: Extract path from the DLL registy entries
  for %%A in ("!gmodSteamPath!") do set gmodSteamPath=%%~dpA

  echo Steam client path: [!gmodSteamPath!]^^!

  echo Searching for GMOD installation across all libraries:

  for /F "usebackq tokens=*" %%A in ("!gmodSteamPath!config\libraryfolders.vdf") do (
    echo.%%A| FIND /I "path">Nul && (
      :: Rewrite the content in the variable
      set "gmodLibPath=%%A"

      :: Swap the slashes for windows
      set "gmodLibPath=!gmodLibPath:/=\!"

      :: Replace "path" substring
      set "gmodLibPath=!gmodLibPath:"path"= %!

      :: Replace all double quotes with spaces
      set "gmodLibPath=!gmodLibPath:"= %!

      :: Replace double slashes with single slashes
      set "gmodLibPath=!gmodLibPath:\\=\%!

      :: Trim the leading and the trailing spaces
      for /f "tokens=*" %%Z in ("!gmodLibPath!") do set gmodLibPath=%%~dpnxZ
      set gmodLibPath=!gmodLibPath!

      :: Search for GMOD executable and mark the library as active
      if exist "!gmodLibPath!\!gmodAppPath!\gmod.exe" (
        echo [V] Binary library: !gmodLibPath!
        set "gmodBinPath=!gmodLibPath!\!gmodAppPath!\bin"
        goto :BIN_LIBRARY
      ) else (
        echo [X] Binary library: !gmodLibPath!
      )
    )
  )
)

:BIN_LIBRARY
echo [B] !gmodBinPath!

:: Tunnel the value out of the SETLOCAL scope
endlocal & set "%~1=%gmodBinPath%"
