@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ===================== Logging =====================
set "LOGDIR=%TEMP%\CleanupLogs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

set "LOGFILE=%LOGDIR%\cleanup_%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log"
set "LOGFILE=%LOGFILE: =0%"

echo ====================================== >> "%LOGFILE%"
echo Cleanup started: %DATE% %TIME% >> "%LOGFILE%"
echo ====================================== >> "%LOGFILE%"

echo Cleanup started...
echo Log file:
echo "%LOGFILE%"
echo.

:: ===================== Functions =====================
:: Function to get free space in bytes for a drive
:: Usage: call :GetFreeSpace C
:GetFreeSpace
set "DRIVE=%~1"
for /f "tokens=3" %%F in ('dir "%DRIVE%\" ^| find "bytes free"') do (
    set "FREESPACE=%%F"
)
echo Drive %DRIVE% free bytes: !FREESPACE! >> "%LOGFILE%"
goto :eof

:: ===================== Disk space BEFORE =====================
echo Disk space BEFORE cleanup: >> "%LOGFILE%"
call :GetFreeSpace C

:: ===================== Resolve paths =====================
set "USERTEMP=%TEMP%"
set "WINTEMP=%SystemRoot%\Temp"
set "PREFETCH=%SystemRoot%\Prefetch"
set "WU_CACHE=%SystemRoot%\SoftwareDistribution\Download"
set "ICONCACHE=%LocalAppData%\IconCache.db"

:: ===================== User TEMP =====================
echo Cleaning user TEMP...
echo [User TEMP] "%USERTEMP%" >> "%LOGFILE%"
if exist "%USERTEMP%" (
    del /f /s /q "%USERTEMP%\*" >> "%LOGFILE%" 2>&1
    for /d %%D in ("%USERTEMP%\*") do rd /s /q "%%D" >> "%LOGFILE%" 2>&1
)

:: ===================== Windows TEMP =====================
echo Cleaning Windows TEMP...
echo [Windows TEMP] "%WINTEMP%" >> "%LOGFILE%"
if exist "%WINTEMP%" (
    del /f /s /q "%WINTEMP%\*" >> "%LOGFILE%" 2>&1
    for /d %%D in ("%WINTEMP%\*") do rd /s /q "%%D" >> "%LOGFILE%" 2>&1
)

:: ===================== Prefetch =====================
echo Cleaning Prefetch...
echo [Prefetch] "%PREFETCH%" >> "%LOGFILE%"
if exist "%PREFETCH%" (
    del /f /q "%PREFETCH%\*" >> "%LOGFILE%" 2>&1
)

:: ===================== Windows Update cache =====================
echo Cleaning Windows Update cache...
echo [Windows Update Cache] >> "%LOGFILE%"
net stop wuauserv >> "%LOGFILE%" 2>&1
if exist "%WU_CACHE%" (
    del /f /s /q "%WU_CACHE%\*" >> "%LOGFILE%" 2>&1
)
net start wuauserv >> "%LOGFILE%" 2>&1

:: ===================== Recycle Bin cleanup =====================
echo Cleaning Recycle Bin...
echo [Recycle Bin] >> "%LOGFILE%"
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\$Recycle.Bin" (
        rd /s /q "%%D:\$Recycle.Bin" >> "%LOGFILE%" 2>&1
    )
)

:: ===================== Icon cache cleanup =====================
echo Resetting icon cache...
echo [Icon Cache] >> "%LOGFILE%"
taskkill /f /im explorer.exe >> "%LOGFILE%" 2>&1
timeout /t 2 /nobreak >nul

del /f /q "%ICONCACHE%" >> "%LOGFILE%" 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache*" >> "%LOGFILE%" 2>&1

start explorer.exe

:: ===================== Disk space AFTER =====================
echo Disk space AFTER cleanup: >> "%LOGFILE%"
call :GetFreeSpace C

:: ===================== Finish =====================
echo ====================================== >> "%LOGFILE%"
echo Cleanup finished: %DATE% %TIME% >> "%LOGFILE%"
echo ====================================== >> "%LOGFILE%"

echo.
echo Cleanup completed successfully.
echo Log saved to:
echo "%LOGFILE%"
echo.
pause
