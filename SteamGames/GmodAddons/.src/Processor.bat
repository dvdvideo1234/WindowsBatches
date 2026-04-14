@echo off

setlocal EnableDelayedExpansion

set "procBase=%~n2"
set "procDump=%~f3"
set "procGmad=%~f1"
set "procFile=%~f2"
set "procLogs=%4"
set "procDest=%5"

if "!procDest!" EQU "" (
  set "procDest=!procBase!"
)

echo DELETE: [!procDump!\!procDest!]
if exist "!procDump!\!procDest!\" rd /S /Q "!procDump!\!procDest!\"

echo DTDUMP: [!procDump!] >> "!procLogs!"
echo BINDIR: [!procGmad!] >> "!procLogs!"
echo EXFILE: [!procFile!] >> "!procLogs!"
echo FIBASE: [!procBase!] >> "!procLogs!"
call "!procGmad!\gmad.exe" extract -file "!procFile!" -out "!procDump!\!procDest!" >> "!procLogs!"

echo "AddonInfo"> !procDump!\!procDest!\addon.txt
echo {>> !procDump!\!procDest!\addon.txt
echo   "name"         "!procBase!">> !procDump!\!procDest!\addon.txt
echo   "version"      "2">> !procDump!\!procDest!\addon.txt
echo   "up_date"      "%date% %time%">> !procDump!\!procDest!\addon.txt
echo   "author_name"  "">> !procDump!\!procDest!\addon.txt
echo   "author_email" "">> !procDump!\!procDest!\addon.txt
echo   "author_url"   "">> !procDump!\!procDest!\addon.txt
echo   "info"         "">> !procDump!\!procDest!\addon.txt
echo   "override"     "0">> !procDump!\!procDest!\addon.txt
echo }>> !procDump!\!procDest!\addon.txt
