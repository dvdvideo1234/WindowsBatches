@echo off

set mgrPath=%programfiles%\Oracle\VirtualBox\
set mgrVDIR=F:\Virtuals\UbuntuLFD\UbuntuLFD.vdi
set mgrSIZE=%1

call "%mgrPath%VBoxManage.exe" modifyhd "%mgrVDIR%" --resize %mgrSIZE%

timeout 500
