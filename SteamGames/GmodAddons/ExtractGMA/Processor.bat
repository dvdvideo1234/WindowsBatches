@echo off

rem rd /S /Q %~f3%~n2

echo Delete: %~f3%~n2 >> "%~f3\process.log"

call %~f1/gmad.exe extract -file "%~f2" -out "%~f3%~n2"

echo "AddonInfo"> %~f3%~n2\addon.txt
echo {>> %~f3%~n2\addon.txt
echo   "name"         "%~n2">> %~f3%~n2\addon.txt
echo   "version"      "2">> %~f3%~n2\addon.txt
echo   "up_date"      "%date% %time%">> %~f3%~n2\addon.txt
echo   "author_name"  "">> %~f3%~n2\addon.txt
echo   "author_email" "">> %~f3%~n2\addon.txt
echo   "author_url"   "">> %~f3%~n2\addon.txt
echo   "info"         "">> %~f3%~n2\addon.txt
echo   "override"     "0">> %~f3%~n2\addon.txt
echo }>> %~f3%~n2\addon.txt
