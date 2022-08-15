:: Switch drive folder
cd /d "%1"

:: Populate root
if not exist "TEMP" mkdir "TEMP"

:: Populate one drive
if not exist "ONEDRIVE" mkdir "ONEDRIVE"

:: Populate cache for browsers
if not exist "CACHEFILES" mkdir "CACHEFILES"
cd "CACHEFILES"

if not exist "EDGE" mkdir "EDGE"
if not exist "OPERA" mkdir "OPERA"
if not exist "CHROME" mkdir "CHROME"
if not exist "OPERAGX" mkdir "OPERAGX"
if not exist "FIREFOX" mkdir "FIREFOX"
if not exist "IEXPLORER" mkdir "IEXPLORER"

exit 0
