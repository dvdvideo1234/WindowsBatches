@echo off
setlocal enabledelayedexpansion

set razerServicesNum=4

set "razerServices[1]=Razer Chroma SDK Server"
set "razerServices[2]=Razer Chroma SDK Service"
set "razerServices[3]=Razer Game Manager Service"
set "razerServices[4]=Razer Synapse Service"

set /p razerProcess="Convert services to manual [y/N] ? "

if /I "%razerProcess%" EQU "y" (
  set "razerProcess=Y"
)

if /I "%razerProcess%" EQU "Y" (
  for /L %%k in (1,1,%razerServicesNum%) do (
    sc config "!razerServices[%%k]!" start= demand
    echo Processed: !razerServices[%%k]!
  )  
) else (
  sc queryex type= service state= all > all.txt
  sc queryex type= service state= all | find /i "RAZER" > razer.txt
)
