@echo off

setlocal EnableDelayedExpansion

set autoTime=
set /p autoTime="Enter sutdown delay in minutes: "

IF DEFINED autoTime (
  set /a autoTime=!autoTime!*60
  ECHO System shutdown after !autoTime! seconds.
  shutdown /s /t "!autoTime!"  
) ELSE (
  ECHO The pending shutdown has been aborted.
  shutdown /a
)

timeout 500
