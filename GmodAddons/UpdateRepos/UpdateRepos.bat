@echo off

setlocal EnableDelayedExpansion

set "gitUpFolder=%1"
set "gitUpCurren=%~dp0"
set "gitUpGitExe=%GIT_HOME%\bin\git.exe"

cd /d !gitUpFolder!

for /D %%a in (.\*) do (
  echo ------- Updating repository [%%a] -------
  echo.
  cd %%a
  if exist ".git\" ( call "!gitUpGitExe!" pull )
  cd /d !gitUpFolder!
)

timeout 500

exit 0
