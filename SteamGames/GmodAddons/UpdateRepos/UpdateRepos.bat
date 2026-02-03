@echo off

setlocal EnableDelayedExpansion

set "gitUpFolder=%1"
set "gitUpCurren=%~dp0"
set "gitUpFileLg=%gitUpCurren%\status.log"
set "gitTortoise=C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe"

if exist "!gitUpFileLg!" del !gitUpFileLg!

cd /d "!gitUpFolder!"

echo Begin: [!gitUpFolder!]
echo Begin: [!gitUpFolder!]>>!gitUpFileLg!

for /D %%a in (*) do (
  cd "%%a"
  if exist ".git\" (
    :: Mark the repository processed
    echo Repository: [V][%%a]
    echo Repository: [V][%%a]>>!gitUpFileLg!
    :: Prepare to press enter on OK
    echo   Powershell: [%date% %time%]>>!gitUpFileLg!
    start "PS_Enter" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File !gitUpCurren!\KeyPress.ps1 ^
      -Window "Pull - TortoiseGit" ^
      -Press " ~"^
      -SleepSt 2 ^
      -SleepEn 0 ^
      -Verbose "1"
    :: The GIT dialog appears
    echo   Tortoise [%date% %time%]>>!gitUpFileLg!
    call "!gitTortoise!" /command:pull ^
                         /path:"!gitUpFolder!\%%a" ^
                         /autostart ^
                         /closeonend:2 && (
      echo   Tortoise : [V]>>!gitUpFileLg!
    ) || ( :: Un case of error report it
      echo   Tortoise : [X][!errorlevel!]>>!gitUpFileLg!
    ) 
  ) else (
    echo Repository: [X][%%a]
    echo Repository: [X][%%a]>>!gitUpFileLg!
  )
  cd /d "!gitUpFolder!"
)

:: timeout 500

:: exit 0
