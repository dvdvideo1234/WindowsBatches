@echo off
del /s /f /q C:\Windows\temp\*.*
rd /s /q C:\Windows\temp
md C:\Windows\temp
del /s /f /q C:\Windows\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
deltree /y C:\Windows\tempor~1
deltree /y C:\Windows\temp
deltree /y C:\Windows\tmp
deltree /y C:\Windows\ff*.tmp
deltree /y C:\Windows\history
deltree /y C:\Windows\cookies
deltree /y C:\Windows\recent
deltree /y C:\Windows\spool\printers
deltree /y C:\Windows\SoftwareDistribution\Download
del C:\WIN386.SWP
cls
