echo Create office deployment settings

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://config.office.com/deploymentsettings"

timeout 5000

echo Download office deployment tool

call %windir%\system32\cmd.exe /c "start microsoft-edge:https://www.microsoft.com/en-us/download/details.aspx?id=49117"

timeout 5000

:: Office Installation
:: cd c:\office
:: setup.exe /download config.xml
:: setup.exe /configure config.xml
:: 
:: ACTIVATION 
::
:: KMS Server (Backup)
:: kms.03k.org
:: kms8.MSGuides.com
:: kms9.MSGuides.com

:: cscript ospp.vbs /sethst:kms.03k.org
:: cscript ospp.vbs /act
:: cscript ospp.vbs /dhistorykms
