@echo off

set UserPaths=""
set UserFoder="%1"
set "UserClear=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"


for /F "Tokens=1,2*" %%A in ('reg query "%UserClear%"') do (
    echo %%A : %%B : %%C
)
