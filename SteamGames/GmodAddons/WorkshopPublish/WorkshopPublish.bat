:: Hard reset the HEAD: git push origin +<NEW_HEAD_COMMIT_HASH>:master
:: 6af74344a888bdf9fbb35d887c3f77691820a50e
:: git push origin +6af74344a888bdf9fbb35d887c3f77691820a50e:master
:: cd /e
:: cd Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master

@echo off

setlocal EnableDelayedExpansion

set "gmadGitHEAD="
set "gmadNameItem="
set "gmadTestMode="
set "gmadSteamPath="
set "gmadLibPath="
set "gmadBinPath=%2"
set "gmadRevPath=%1"
set "gmadBasePath=%~dp0"
set "gmadRevDesc=.workshop"
set "gmadRevDest=Workshop"
set "gmadTime=%date% %time%"
set "gmadPathGIT=%GIT_HOME%\bin\git.exe"
set "gmadNameLOG=gmad_log.txt"
set "gmadNameGIT=gmad_git.txt"
set "gmadCopyEXC=exclude_copy.txt"
set "gmadAppPath=steamapps\common\GarrysMod"
set "gmadSteamPID=HKCU\Software\Valve\Steam\ActiveProcess"

echo %gmadBasePath%

:: Revision path defaults to current path
if not defined gmadRevPath (
  echo Repository path not provided^^!

  :: Swap the slashes for windows
  set "gmadRevPath=!gmadBasePath:/=\!"

  :: Replace double slashes with single slashes
  set "gmadRevPath=!gmadRevPath:\\=\%!

  :: Remove the last slash when present
  if !gmadRevPath:~-1!==\ set gmadRevPath=!gmadRevPath:~0,-1!

  echo [X] Addon path: [!gmadRevPath!]^^!
) else (
  echo [V] Addon path: [!gmadRevPath!]^^!
)

cd /d !gmadRevPath!

if not defined gmadBinPath (
  set "gmadLibPath=!gmadRevPath!"

  echo Searching for game binary via addon^^!

  for /L %%I in (1, 1, 4) do (

    :: Swap the slashes for windows
    set "gmadLibPath=!gmadLibPath:/=\!"

    :: Replace double slashes with single slashes
    set "gmadLibPath=!gmadLibPath:\\=\%!

    :: Remove the last slash when present
    if !gmadLibPath:~-1!==\ set gmadLibPath=!gmadLibPath:~0,-1!

    :: Trim the leading and the trailing spaces
    for /f "tokens=*" %%Z in ("!gmadLibPath!") do set gmadLibPath=%%~dpnxZ
    set gmadLibPath=!gmadLibPath!

    :: They the current addon path
    if exist "!gmadLibPath!\gmod.exe" (
      echo [V] Binary addon: !gmadLibPath!
      set "gmadBinPath=!gmadLibPath!\bin"
      goto :BIN_ADDON
    ) else (
      echo [X] Binary addon: !gmadLibPath!
    )

    :: Remove `/<ADDON_FOLDER>`
    for %%A in ("!gmadLibPath!") do set gmadLibPath=%%~dpA
  )
)

:BIN_ADDON

if not defined gmadBinPath (
  echo Searching for game binary via library^^!

  :: Retrieve steam DLL install location
  for /F "Tokens=1,2*" %%A in ('reg query !gmadSteamPID!') do (
      If "%%A" equ "SteamClientDll" set "gmadSteamPath=%%C")

  :: Replace slashes for windows
  set "gmadSteamPath=!gmadSteamPath:/=\!"

  :: Extract path from the DLL registy entries
  for %%A in ("!gmadSteamPath!") do set gmadSteamPath=%%~dpA

  echo Steam client path: [!gmadSteamPath!]^^!

  echo Searching for GMOD installation across all libraries:

  for /F "usebackq tokens=*" %%A in ("!gmadSteamPath!config\libraryfolders.vdf") do (
    echo.%%A| FIND /I "path">Nul && (
      :: Rewrite the content in the variable
      set "gmadLibPath=%%A"

      :: Swap the slashes for windows
      set "gmadLibPath=!gmadLibPath:/=\!"

      :: Replace "path" substring
      set "gmadLibPath=!gmadLibPath:"path"= %!

      :: Replace all double quotes with spaces
      set "gmadLibPath=!gmadLibPath:"= %!

      :: Replace double slashes with single slashes
      set "gmadLibPath=!gmadLibPath:\\=\%!

      :: Trim the leading and the trailing spaces
      for /f "tokens=*" %%Z in ("!gmadLibPath!") do set gmadLibPath=%%~dpnxZ
      set gmadLibPath=!gmadLibPath!

      :: Search for GMOD executable and mark the library as active
      if exist "!gmadLibPath!\!gmadAppPath!\gmod.exe" (
        echo [V] Binary library: !gmadLibPath!
        set "gmadBinPath=!gmadLibPath!\!gmadAppPath!\bin"
        goto :BIN_LIBRARY
      ) else (
        echo [X] Binary library: !gmadLibPath!
      )
    )
  )
)

:BIN_LIBRARY

echo Game binary path: [!gmadBinPath!]^^!

if not exist "!gmadRevDesc!" (
  echo Publish description required [!gmadRevDesc!]^^!
  echo Path: !gmadRevDesc!
)

:: Extract the information from the workshop conf file
for /f "tokens=1,2 delims=:" %%i in (!gmadRevDesc!) do (
  :: Extract workshop ID
  if "%%i" EQU "WSID" (
    set "gmadID=%%j"
    echo Extracting setting [%%i][%%j]
  )
  :: Extract repository name in github
  if "%%i" EQU "REPO" (
    set "gmadName=%%j"
    echo Extracting setting [%%i][%%j]
  )
  :: Extract addon name
  if "%%i" EQU "ADDN" (
    set "gmadNameItem=%%j"
    echo Extracting setting [%%i][%%j]
  )
  :: Define what is to be extracted
  if "%%i" EQU "DATA" (
    set "gmadDirs=%%j"
    echo Extracting setting [%%i][%%j]
  )
)

:: Repository name is not defined
if not defined gmadName (
  echo Please define the [REPO] parameter in [!gmadRevDesc!]^^!
  echo Path: !gmadRevPath!\!gmadRevDesc!
  timeout 100
  goto :EOF
)

title Addon !gmadName! updater/publisher

if not defined gmadNameItem (
  echo Please define the [ADDN] parameter in [!gmadRevDesc!]^^!
  echo Path: !gmadRevPath!\!gmadRevDesc!
  timeout 100
  goto :EOF
)

set "gmadCommits=https://github.com/dvdvideo1234/!gmadName!/commit/"
set "gmadRevTools=data\!gmadNameItem!\tools"

echo Press Crtl+C to terminate^^!
echo Press a key if you do not want to wait^^!
echo Npp Find --\h{1,}\n-- replace --\n-- in dos format before commit^^!
echo Extracting repository source contents^^!
if exist "!gmadNameLOG!" del "!gmadNameLOG!"
if exist "!gmadNameGIT!" del "!gmadNameGIT!"
if exist "!gmadRevDest!" rd /S /Q "!gmadRevDest!"

timeout 10

if exist "!gmadRevPath!\!gmadRevTools!\workshop\!gmadCopyEXC!" (
  echo Utilizing the local copy exclude^^!
  echo Exclude: !gmadRevTools!\workshop\!gmadCopyEXC!
  set "gmadCopyEXC=!gmadRevTools!\workshop\!gmadCopyEXC!"
) else (
  echo Utilizing the global copy exclude^^!
  echo Exclude: !gmadBasePath!!gmadCopyEXC!
  set "gmadCopyEXC=!gmadBasePath!!gmadCopyEXC!"
)

md "!gmadRevDest!\!gmadName!" >> !gmadNameLOG!

:: Keep percent instead exclamation mark here
for %%i in %gmadDirs% do (
  if exist "!gmadRevPath!\%%i" (
    echo [V] Addon content: %%i
    call xcopy "!gmadRevPath!\%%i" "!gmadRevDest!\!gmadName!\%%i" /EXCLUDE:!gmadCopyEXC! /E /C /I /F /R /Y >> !gmadNameLOG!
  ) else (
    echo [X] Addon content: %%i
  )
)

echo Create the [addon.json] file^^!
call copy "!gmadRevTools!\workshop\addon.json" "!gmadRevDest!\!gmadName!\addon.json" >> !gmadNameLOG!

echo Create the [!gmadName!.gma] file^^!
call "!gmadBinPath!\gmad.exe" create -folder "!gmadRevDest!\!gmadName!" -out "!gmadRevDest!\!gmadName!.gma" >> !gmadNameLOG!

echo Obtain the latest repository commit log^^!
for /F "tokens=*" %%i in ('call "!gmadPathGIT!" rev-parse HEAD') do (set "gmadGitHEAD=%%i")

call echo !gmadTime! >> !gmadNameGIT!
call echo. >> !gmadNameGIT!
call echo !gmadCommits!!gmadGitHEAD! >> !gmadNameGIT!
call echo. >> !gmadNameGIT!

call "!gmadPathGIT!" log -1 >> !gmadNameGIT!

call "%WINDIR%\System32\notepad.exe" "!gmadNameGIT!"

timeout 10

if defined gmadID (
  echo Updating addon [!gmadName!]^^!
  if "!gmadTestMode!" EQU "Y" (
    echo call "!gmadBinPath!\gmpublish.exe" update^
      -addon "!gmadRevDest!\!gmadName!.gma"^
      -id "!gmadID!"^
      -icon "!gmadRevTools!\pictures\icon.jpg"^
      -changes "Generated by batch" >> !gmadNameLOG!
  ) else (
    call "!gmadBinPath!\gmpublish.exe" update^
      -addon "!gmadRevDest!\!gmadName!.gma"^
      -id "!gmadID!"^
      -icon "!gmadRevTools!\pictures\icon.jpg"^
      -changes "Generated by batch" >> !gmadNameLOG!
  )
) else (
  echo Creating addon [!gmadName!]^^!
  if "!gmadTestMode!" EQU "Y" (
    echo call "!gmadBinPath!\gmpublish.exe" create^
      -addon "!gmadRevDest!\!gmadName!.gma"^
      -icon "!gmadRevTools!\pictures\icon.jpg" >> !gmadNameLOG!
  ) else (
    call "!gmadBinPath!\gmpublish.exe" create^
      -addon "!gmadRevDest!\!gmadName!.gma"^
      -icon "!gmadRevTools!\pictures\icon.jpg" >> !gmadNameLOG!
  )
)

echo Cleaning up after publush [!gmadName!]^^!

timeout 500

rd /S /Q "!gmadRevDest!"

del "!gmadNameLOG!"
del "!gmadNameGIT!"

cd /d !gmadBasePath!

:EOF
