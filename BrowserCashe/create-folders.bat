:: Switch drive folder
cd /d %1

:: cd /d E:\GIT\WindowsBatches\BrowserCashe
:: create-folders.bat "V:\"

:: Populate root
if not exist "TEMP" mkdir "TEMP"

:: Populate cache
if not exist "CACHEFILES" mkdir "CACHEFILES"
cd "CACHEFILES"

if not exist "OPERA"    mkdir "OPERA"
if not exist "OPERAGX"  mkdir "OPERAGX"
if not exist "FIREFOX"  mkdir "FIREFOX"
if not exist "CHROME"   mkdir "CHROME"
if not exist "INTERNET EXPLORER" mkdir "INTERNET EXPLORER"

exit 0
