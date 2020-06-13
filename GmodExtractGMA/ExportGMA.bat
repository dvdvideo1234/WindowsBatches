@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

:: The user configures the following

set BinPath="F:\Games\Steam\steamapps\common\GarrysMod\bin"
set OutPath="O:\Documents\GmodAddons12-13\Gmod13\GMAD_EXTRACTED"
set OnlyAddons=()
set SkipAddons=()

:: The rest of the file is automatic

set OnlyAddonsCount=0
set SkipAddonsCount=0
set "StartTime=%date% %time%"
set FilePathCD=%~dp0
set FileExt=gma

del /f /q %OutPath%\*.log

for %%i in %OnlyAddons% do (
  set SkipAddonsCount=0
  for %%j in %SkipAddons% do (
    if /I "%%i" EQU "%%j" (
      set /A SkipAddonsCount=!SkipAddonsCount!+1
    )
  )
  if /I "!SkipAddonsCount!" EQU "0" (
    echo Processing [%FilePathCD%\%%i.!FileExt!]
    call Processor.bat %BinPath%, %FilePathCD%\%%i.!FileExt!, %OutPath%
    set /A OnlyAddonsCount=!OnlyAddonsCount!+1
  ) else (
    echo Skipped [%%i.!FileExt!]
  )
)

if /I "!OnlyAddonsCount!" NEQ "0" (
  echo "Selected addons extracted !"
  timeout 100
) else (
  for /r %%i in (*.!FileExt!) do (
    set SkipAddonsCount=0
    for %%j in %SkipAddons% do (

      echo II %%i
      echo JJ %FilePathCD%\%%j.!FileExt!

      if /I "%%i" EQU "%FilePathCD%\%%j.!FileExt!" (
        set /A SkipAddonsCount=!SkipAddonsCount!+1
      )
    )
    if /I "!SkipAddonsCount!" EQU "0" (
      echo Processing [%%i]
      call Processor.bat %BinPath%, %%i, %OutPath%
    ) else (
      echo Skipped [%%i]
    )
  )
  timeout 100
)

echo Start %StartTime%
echo End   %time%
