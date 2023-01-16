@echo off

setlocal EnableDelayedExpansion

set "gitUpFolder=%1"
set "gitUpCurren=%~dp0"
set "gitUpFileLg=%gitUpCurren%\status.log"
set "gitTortoise=C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe"
  
if exist "!gitUpFileLg!" del !gitUpFileLg!

cd /d "!gitUpFolder!"

for /D %%a in (.\*) do (
  cd "%%a"
  if exist ".git\" (
    echo Processing repository: [%%a]
    call "!gitTortoise!" /command:pull^
                         /path:"!gitUpFolder!\%%a"^
                         /closeonend:2>>!gitUpFileLg! && (
      echo [V] Updating repository: [%%a]>>!gitUpFileLg!
    ) || (
      echo [X] Updating repository: [%%a]>>!gitUpFileLg!
    ) 
  )
  cd /d "!gitUpFolder!"
)

timeout 500

exit 0
