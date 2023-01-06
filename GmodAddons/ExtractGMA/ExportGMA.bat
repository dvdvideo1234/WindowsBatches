@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

:: The user configures the following

set BinPath=D:\Games\Steam\steamapps\common\GarrysMod\bin
set SrcPath=F:\GIT\WindowsBatches\GmodExtractGMA\DATA
set OnlyAddons=()
set SkipAddons=()

:: The rest of the file is automatic

set FileExt=gma
set OutPath=%~dp0
set OnlyAddonsCount=0
set SkipAddonsCount=0
set "StartTime=%date% %time%"

del /f /q %OutPath%*.log

echo Processing addons has started^^! >> %OutPath%process.log

for %%i in %OnlyAddons% do (
  set /A OnlyAddonsCount=!OnlyAddonsCount!+1
)

for %%j in %SkipAddons% do (
  set /A SkipAddonsCount=!SkipAddonsCount!+1
)

echo ONLY: %OnlyAddonsCount% >> %OutPath%process.log
echo SKIP: %SkipAddonsCount% >> %OutPath%process.log

echo CHECK: dir !SrcPath!\*.!FileExt! /b /s >> %OutPath%process.log

for /F "delims==" %%k in ('dir !SrcPath!\*.!FileExt! /b /s') do (
  echo ADDON BASE: %%k >> !OutPath!process.log
  set /A OnlyAddonsMatch=0
  set /A SkipAddonsMatch=0
  if !SkipAddonsCount! GTR 0 (
    for %%j in %SkipAddons% do (
      call Contain.bat %%k %%j

      echo K: %%k >> !OutPath!process.log
      echo K: %%j >> !OutPath!process.log

      if !ERRORLEVEL! EQU 1 (
        echo ADDON SKIP: %%k >> !OutPath!process.log
        set /A SkipAddonsMatch=!SkipAddonsMatch!+1
      )
    )
  )

  echo SKIP: !SkipAddonsMatch!

  if !OnlyAddonsCount! GTR 0 (
    for %%i in %OnlyAddons% do (
      call Contain.bat %%k %%i

      if !ERRORLEVEL! EQU 1 (
        if !SkipAddonsMatch! EQU 0 (
          echo ADDON ONLY: %%k >> !OutPath!process.log
          call Processor !BinPath! %%k !OutPath!
        )
      )
    )
  ) else (
    if !SkipAddonsMatch! EQU 0 (
      echo ADDON DIRE: %%k >> !OutPath!process.log
      call Processor !BinPath! %%k !OutPath!
    )
  )
)

timeout 100

echo Start: %StartTime% >> %OutPath%process.log
echo End  : %date% %time% >> %OutPath%process.log
