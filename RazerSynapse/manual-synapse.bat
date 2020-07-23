@echo off
setlocal enabledelayedexpansion

set /p razerProcess="Convert services to manual [y/N] ? "

if /I "%razerProcess%" EQU "y" (
  set "razerProcess=Y"
)

if /I "%razerProcess%" EQU "Y" (
  for /F "tokens=*" %%k in ('type "razer.txt"') do (
    set "var=%%k"
    echo Processed:[!var:~14!]
    sc config "!var:~14!" start= demand
  )
) else (
  del /q /f all.txt
  del /q /f razer.txt
  sc queryex type= service state= all>all.txt
  sc queryex type= service state= all | find /i "RAZER" | find /i "SERVICE_NAME">razer.txt
)
