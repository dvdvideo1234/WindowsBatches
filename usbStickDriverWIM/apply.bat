:: dism /cleanup-wim
:: dism /get-mountedwiminfo
:: Imagex /unmount %dismDIRM%
:: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WIMMount\Mounted Images\

@echo off

set dismPath=%~dp0
set dismFile=%1
set dismID=%2
set dismTime=%date:~-4%_%date:~3,2%_%date:~0,2%__%time:~0,2%_%time:~3,2%_%time:~6,2%
set dismDIRM=%dismPath%Mount1

if not exist "%dismPath%Backup\" mkdir %dismPath%Backup
if not exist "%dismDIRM%\"  mkdir %dismDIRM%

echo F|xcopy "%dismPath%%dismFile%.wim" "%dismPath%Backup/%dismFile%$%dismTime%.wim"

call dism /mount-wim /wimfile:%dismPath%%dismFile%.wim /index:%dismID% /mountdir:%dismDIRM%
call dism /image:%dismDIRM% /add-driver:"%dismPath%Drivers" /recurse
call dism /unmount-wim /mountdir:%dismDIRM% /commit
::call dism /unmount-wim /mountdir:%dismDIRM% /discard


:: rmdir %dismDIRM% /s /q
echo Remove mount: %dismDIRM%

timeout 500
