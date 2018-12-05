@echo off

set dismPath=%~dp0
set dismFile=%1
set dismID=%2
set dismTime=%date:~-4%_%date:~3,2%_%date:~0,2%__%time:~0,2%_%time:~3,2%_%time:~6,2%

if not exist "%dismPath%Backup\" mkdir %dismPath%Backup
if not exist "%dismPath%Mount\"  mkdir %dismPath%Mount

echo F|xcopy "%dismPath%%dismFile%.wim" "%dismPath%Backup/%dismFile%$%dismTime%.wim"

call dism /mount-wim /wimfile:%dismPath%%dismFile%.wim /index:%dismID% /mountdir:%dismPath%Mount
call dism /image:%dismPath%Mount /add-driver:"%dismPath%Drivers" /recurse
call dism /unmount-wim /mountdir:%dismPath%Mount /commit

echo Remove mount directory: %dismPath%Mount

timeout 500
