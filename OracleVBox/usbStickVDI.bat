@echo off

set usbPath=%~dp0
set usbDisk=%1
set usbVBox=%programfiles%\Oracle\VirtualBox\

echo %usbVBox%

call "%usbVBox%VBoxManage.exe" internalcommands createrawvmdk -filename "%usbPath%usb.vmdk" -rawdisk \\.\PhysicalDrive%usbDisk%

timeout 500
