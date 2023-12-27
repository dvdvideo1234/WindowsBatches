echo Create office deployment settings

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://config.office.com/deploymentsettings"

timeout 5000

echo Download office deployment tool

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://www.microsoft.com/en-us/download/details.aspx?id=49117"

timeout 5000
