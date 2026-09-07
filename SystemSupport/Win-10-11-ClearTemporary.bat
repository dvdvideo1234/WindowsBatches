@echo off
setlocal EnableDelayedExpansion

:: Logging 
set "LOGDIR=%~dp0"

set "LOGFILE=%LOGDIR%\cleanup.log"

echo Cleanup started: %DATE% %TIME% >> "%LOGFILE%"

echo Cleanup started...
echo Log file: "%LOGFILE%"

:: Disk space BEFORE 
call :GetFreeSpace C "Disk space BEFORE cleanup" >> "%LOGFILE%"

:: Resolve paths 
set "USERTEMPS=%TEMP%"
set "WINDTEMPS=%SystemRoot%\Temp"
set "PREFFETCH=%SystemRoot%\Prefetch"
set "WUPDCACHE=%SystemRoot%\SoftwareDistribution\Download"
set "ICONCACHE=%LocalAppData%\IconCache.db"
set "EXPLCACHE=%LocalAppData%\Microsoft\Windows\Explorer\iconcache*"

:: User TEMP 
echo Cleaning User TEMP... [%USERTEMPS%]
echo [User TEMP] "%USERTEMPS%" >> "%LOGFILE%"
if exist "%USERTEMPS%" (
    del /f /s /q "%USERTEMPS%\*" >> "%LOGFILE%" 2>&1
    for /d %%D in ("%USERTEMPS%\*") do rd /s /q "%%D" >> "%LOGFILE%" 2>&1
)

:: Windows TEMP 
echo Cleaning Windows TEMP... [%WINDTEMPS%]
echo [Windows TEMP] "%WINDTEMPS%" >> "%LOGFILE%"
if exist "%WINDTEMPS%" (
    del /f /s /q "%WINDTEMPS%\*" >> "%LOGFILE%" 2>&1
    for /d %%D in ("%WINDTEMPS%\*") do rd /s /q "%%D" >> "%LOGFILE%" 2>&1
)

:: Prefetch 
echo Cleaning Prefetch... [%PREFFETCH%]
echo [Prefetch] "%PREFFETCH%" >> "%LOGFILE%"
if exist "%PREFFETCH%" (
    del /f /q "%PREFFETCH%\*" >> "%LOGFILE%" 2>&1
)

:: Windows Update cache 
echo Cleaning Update cache... [%WUPDCACHE%]
echo [Update Cache] >> "%LOGFILE%"
net stop wuauserv >> "%LOGFILE%" 2>&1
if exist "%WUPDCACHE%" (
    del /f /s /q "%WUPDCACHE%\*" >> "%LOGFILE%" 2>&1
)
net start wuauserv >> "%LOGFILE%" 2>&1

:: Recycle Bin cleanup 
echo Cleaning Recycle Bin...
echo [Recycle Bin] >> "%LOGFILE%"
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\$Recycle.Bin" (
        rd /s /q "%%D:\$Recycle.Bin" >> "%LOGFILE%" 2>&1
    )
)

:: Icon cache cleanup 
echo [Icon Cache] >> "%LOGFILE%"
taskkill /f /im explorer.exe >> "%LOGFILE%" 2>&1
timeout /t 2 /nobreak >nul

echo Resetting icon cache... [%ICONCACHE%]
del /f /a /q "%ICONCACHE%" >> "%LOGFILE%" 2>&1

echo Resetting icon cache... [%EXPLCACHE%]
del /f /a /q "%EXPLCACHE%" >> "%LOGFILE%" 2>&1

start explorer.exe

:: Disk space AFTER 
call :GetFreeSpace C "Disk space AFTER cleanup" >> "%LOGFILE%"

:: Finish 
echo Cleanup finished: %DATE% %TIME% >> "%LOGFILE%"

pause

goto :eof 

:: Dedicated function area

:: Function to get free space in bytes for a drive
:: Usage: call :GetFreeSpace C
:GetFreeSpace
set "SPACE_DRIVE=%~1"
set "SPACE_MESSG=%~2"
set "SPACE_DRIVE=%SPACE_DRIVE:\=%"
set "SPACE_FREMB="
 
:: Use 'where' to completely avoid quote-stripping query errors
for /f %%F in ('powershell -Command "[math]::Round((Get-CimInstance Win32_LogicalDisk | where DeviceID -eq '%SPACE_DRIVE%:').FreeSpace / 1MB)"') do (
    set "SPACE_FREMB=%%F"
)

echo !SPACE_MESSG!: !SPACE_FREMB! MB
goto :eof