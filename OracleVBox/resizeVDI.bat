@echo off

set mgrPath=%programfiles%\Oracle\VirtualBox\

for %%i in (*.vdi) do (
  set mgrMB=
  set /p mgrMB="New size in MB ( %%i ): "

  IF DEFINED mgrMB (
    echo "Resizing %%i to %mgrMB% MB..."
    
    call "%mgrPath%VBoxManage.exe" modifyhd "%%i" --resize "%mgrMB%"
    
  ) ELSE (
    echo "Skipping %%i due to user request !"
  )
)

timeout 500
