@echo off

rem Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

rem The user configures the following

rem set "gma_ext_base=%1"
rem set "gma_ext_base=I:\SteamLibrary\steamapps\workshop\content\4000"
set "gma_ext_base="
set "gma_ext_gbin="
set "gma_ext_wsid="
set "gma_ext_wstg="
set "gma_ext_fext="

set gma_ext_adoy=()
set gma_ext_adsk=()

rem The rest of the file is automatic
set /a "gma_ext_cont=0"
set /a "gma_ext_curr=0"
set /a "gma_ext_prco=0"
set "gma_ext_path=%~dp0"
set "gma_ext_only=0"
set "gma_ext_skip=0"
set "gma_ext_time=%date% %time%"

rem Extract filder relative to game bin
call ..\.src\GamePath.bat gma_ext_gbin

if "!gma_ext_base!" EQU "" (
  if "!gma_ext_gbin!" EQU "" (
    set "gma_ext_base=%GMOD_HOME%\garrysmod\addons"
    echo Source path empty^^!
    echo Default to: !gma_ext_base!
  ) else (
    set "gma_ext_base=!gma_ext_gbin!\..\..\..\workshop\content\4000"
    echo Source path obtained^^!
    echo Default to: !gma_ext_base!
  )
)

rem Destination path
set "gma_ext_dest=%gma_ext_path%\OUTPUT"
if not exist %gma_ext_dest% mkdir %gma_ext_dest%

if exist "%gma_ext_dest%\*" (
  del /f /s /q "%gma_ext_dest%\*" >nul 2>&1
  for /d %%D in ("%gma_ext_dest%\*") do rd /s /q "%%~fD"
)

rem Log file path
set "gma_ext_logs=%gma_ext_path%process.log"

echo BASE: !gma_ext_path!
echo GBIN: !gma_ext_gbin!
echo SORS: !gma_ext_base!

echo BASE: %gma_ext_path% >> "%gma_ext_logs%"
echo GBIN: %gma_ext_gbin% >> "%gma_ext_logs%"
echo SORS: %gma_ext_base% >> "%gma_ext_logs%"

echo Press ENTER to continue with the extraction^^!

timeout 100

echo Processing addons has started^^! > %gma_ext_logs%

rem Get files count for GMA
set "gma_ext_fext=gma"
for /f %%I in ('call ..\.src\Count.bat "!gma_ext_base!" !gma_ext_fext!') do (
  set "gma_ext_cont=%%I"
)

echo Total [*.!gma_ext_fext!] files found: !gma_ext_cont!^^!
set /a "gma_ext_curr=0"
for /d %%D in ("!gma_ext_base!\*") do (
  set "gma_ext_wsid=%%~nxD"
  for /F "delims==" %%E in ('dir "%%~fD\*.!gma_ext_fext!" /b /s 2^>nul') do (
    set "gma_ext_wstg=%%~fE"
    call ..\.src\Increment.bat !gma_ext_curr! gma_ext_curr
    call ..\.src\Percent.bat !gma_ext_curr! !gma_ext_cont! gma_ext_prco
    echo ADDON [!gma_ext_wsid!][!gma_ext_curr! of !gma_ext_cont!][!gma_ext_prco!]: %%~nxE
    echo ADDON [!gma_ext_wsid!][!gma_ext_curr! of !gma_ext_cont!][!gma_ext_prco!]: %%~nxE >> %gma_ext_logs%
    call copy /v /y "!gma_ext_wstg!" "!gma_ext_dest!\!gma_ext_wsid!.gma" >nul 2>&1
    call ExtractONE.bat "!gma_ext_dest!\!gma_ext_wsid!.gma" Y Y "!gma_ext_logs!"
    del /f /q "!gma_ext_dest!\!gma_ext_wsid!.gma"
    if exist "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!\" (
        call xcopy "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!\*" ^
              "!gma_ext_dest!\!gma_ext_wsid!\" /E /H /C /I /Y >nul 2>&1
        rd /s /q "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!"
    )
    if !gma_ext_curr! GEQ 3 goto :DONE_GMA
  )
)

:DONE_GMA

rem Get files count for BIN
set "gma_ext_fext=bin"
for /f %%I in ('call ..\.src\Count.bat "!gma_ext_base!" !gma_ext_fext!') do (
  set "gma_ext_cont=%%I"
)

echo Total [*.!gma_ext_fext!] files found: !gma_ext_cont!^^!
set /a "gma_ext_curr=0"
for /d %%D in ("!gma_ext_base!\*") do (
  set "gma_ext_wsid=%%~nxD"
  for /F "delims==" %%E in ('dir "%%~fD\*.!gma_ext_fext!" /b /s 2^>nul') do (
    set "gma_ext_wstg=%%~fE"
    call ..\.src\Increment.bat !gma_ext_curr! gma_ext_curr
    call ..\.src\Percent.bat !gma_ext_curr! !gma_ext_cont! gma_ext_prco
    echo ADDON [!gma_ext_wsid!][!gma_ext_curr! of !gma_ext_cont!][!gma_ext_prco!]: %%~nxE
    echo ADDON [!gma_ext_wsid!][!gma_ext_curr! of !gma_ext_cont!][!gma_ext_prco!]: %%~nxE >> %gma_ext_logs%
    call copy /v /y "!gma_ext_wstg!" "!gma_ext_dest!\!gma_ext_wsid!.bin" >nul 2>&1
    call ExtractONE.bat "!gma_ext_dest!\!gma_ext_wsid!.bin" Y Y "!gma_ext_logs!"
    del /f /q "!gma_ext_dest!\!gma_ext_wsid!.bin"
    if exist "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!\" (
        call xcopy "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!\*" ^
              "!gma_ext_dest!\!gma_ext_wsid!\" /E /H /C /I /Y >nul 2>&1
        rd /s /q "!gma_ext_dest!\!gma_ext_wsid!\!gma_ext_wsid!"
    )
    if !gma_ext_curr! GEQ 3 goto :DONE_BIN
  )
)

:DONE_BIN

echo TBEGIN: %gma_ext_time% >> %gma_ext_logs%
echo FINISH: %date% %time% >> %gma_ext_logs%

timeout 100
