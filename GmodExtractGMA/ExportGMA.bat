@echo off

setlocal EnableDelayedExpansion

set FileExt=gma
set BinPath="F:\Games\Steam\steamapps\common\GarrysMod\bin"
set OutPath="K:\Test"
set OnlyAddons=(gm_garage_270610222,train_hopper_car_550767658,train_open_wagon_545309996)
set SkipAddons=(train_open_wagon_545309996)

set OnlyAddonsCount=0
set SkipAddonsCount=0
set StartTime=%time%

for %%i in %OnlyAddons% do (
  set SkipAddonsCount=0
  for %%j in %SkipAddons% do (
    if /I "%%i" EQU "%%j" (
      set /A SkipAddonsCount=!SkipAddonsCount!+1
    )
  )
  if /I "!SkipAddonsCount!" EQU "0" (
    echo Processing [%CD%\%%i.!FileExt!]
    call Processor.bat %BinPath%, %CD%\%%i.!FileExt!, %OutPath%
    set /A OnlyAddonsCount=!OnlyAddonsCount!+1
  ) else (
    echo Skipped [%%i.!FileExt!]
  )
)

if /I "!OnlyAddonsCount!" NEQ "0" (
  echo "Selected addons extracted !"
  timeout 100
) else (
  for /r %%i in (*.gma) do (
    set SkipAddonsCount=0
    for %%j in %SkipAddons% do (

      echo II %%i
      echo JJ %CD%\%%j.!FileExt!

      if /I "%%i" EQU "%CD%\%%j.!FileExt!" (
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
