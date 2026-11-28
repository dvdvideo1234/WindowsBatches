echo Create office deployment settings

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://config.office.com/deploymentsettings"

timeout 5000

echo Download office deployment tool

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://www.microsoft.com/en-us/download/details.aspx?id=49117"

timeout 5000

rem Office Installation
rem cd c:\office
rem setup.exe /download config.xml
rem setup.exe /configure config.xml
rem 
rem ACTIVATION 
rem
rem KMS Server (Backup)
rem kms.03k.org
rem kms8.MSGuides.com
rem kms9.MSGuides.com

rem cscript ospp.vbs /sethst:kms.03k.org
rem cscript ospp.vbs /act
rem cscript ospp.vbs /dhistorykms
