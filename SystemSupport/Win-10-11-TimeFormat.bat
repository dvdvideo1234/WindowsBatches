@echo off

:: reg query "HKCU\Control Panel\International" /V sShortTime

reg add "HKCU\Control Panel\International" /V sTimeFormat /T REG_SZ /D "HH:mm" /F
reg add "HKCU\Control Panel\International" /V sShortTime /T REG_SZ /D "HH:mm" /F
reg add "HKCU\Control Panel\International" /V sShortDate /T REG_SZ /D "yyyy-MM-dd" /F
