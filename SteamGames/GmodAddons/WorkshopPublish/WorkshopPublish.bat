:: Hard reset the HEAD: git push origin +<NEW_HEAD_COMMIT_HASH>:master
:: 6af74344a888bdf9fbb35d887c3f77691820a50e
:: git push origin +6af74344a888bdf9fbb35d887c3f77691820a50e:master
:: cd /e
:: cd Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master

@echo off

setlocal EnableDelayedExpansion

set gmadGitHEAD=
set gmadNameItem=
set gmadTestMode=
set "gmadRevPath=%1"
set "gmadBasePath=%~dp0"
set "gmadRevDesc=.workshop"
set "gmadRevDest=Workshop"
set "gmadTime=%date% %time%"
set "gmadBinPath=%GMOD_HOME%\bin"
set "gmadPathGIT=%GIT_HOME%\bin\git.exe"
set "gmadNameLOG=gmad_log.txt"
set "gmadNameGIT=gmad_git.txt"
set "gmadCopyEXC=exclude_copy.txt"

cd /d !gmadRevPath!

if not exist "!gmadRevDesc!" (
  echo Publish description required [!gmadRevDesc!]^^!
  echo Path: !gmadRevDesc!
)

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

if not defined gmadName (
  echo Please define the [REPO] parameter in [!gmadRevDesc!]^^!
  echo Path: !gmadRevPath!\!gmadRevDesc!
)

title Addon !gmadName! updater/publisher

if not defined gmadNameItem (
  echo Please define the [ADDN] parameter in [!gmadRevDesc!]^^!
  echo Path: !gmadRevPath!\!gmadRevDesc!
)

set "gmadCommits=https://github.com/dvdvideo1234/!gmadName!/commit/"
set "gmadRevTools=data\!gmadNameItem!\tools"

echo Press Crtl+C to terminate^^!
echo Press a key if you do not want to wait^^!
echo Rinning in: !gmadRevPath!
echo Npp Find --\h{1,}\n-- replace --\n-- in dos format before commit^^!
echo Extracting repository source contents^^!
if exist "!gmadNameLOG!" del "!gmadNameLOG!"
if exist "!gmadNameGIT!" del "!gmadNameGIT!"
if exist "!gmadRevDest!" rd /S /Q "!gmadRevDest!"

timeout 10

if not exist "!gmadRevPath!\!gmadRevTools!\workshop\!gmadCopyEXC!" (
  echo Utilizing the global copy exclude^^!
  echo Exclude: !gmadBasePath!!gmadCopyEXC!
  set "gmadCopyEXC=!gmadBasePath!!gmadCopyEXC!"
) else (
  echo Utilizing the local copy exclude^^!
  echo Exclude: !gmadRevTools!\workshop\!gmadCopyEXC!
  set "gmadCopyEXC=!gmadRevTools!\workshop\!gmadCopyEXC!"
)

md "!gmadRevDest!\!gmadName!" >> !gmadNameLOG!
for %%i in %gmadDirs% do ( :: Keep percent instead exclamation mark here
  echo Exporting addon content: %%i
  call xcopy "!gmadRevPath!\%%i" "!gmadRevDest!\!gmadName!\%%i" /EXCLUDE:!gmadCopyEXC! /E /C /I /F /R /Y >> !gmadNameLOG!
)

call copy "!gmadRevTools!\workshop\addon.json" "!gmadRevDest!\!gmadName!\addon.json" >> !gmadNameLOG!
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
