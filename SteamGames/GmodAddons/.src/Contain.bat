@echo off

rem Does containVARB contain containSRCH ?
rem Return the result in ERRORLEVEL
rem When ERRORLEVEL is equal to 1 then true
rem This works perfectly as long as there are no spesial characters

set "containVARB=%1"
set "containSRCH=%2"

rem Because we are comparing spaces will brake the find request
rem Comparing two spaces is the same as comparing any other symbol

set containVARB=%containVARB: =-%
set containSRCH=%containSRCH: =-%

rem echo VARB: %containVARB%
rem echo SRCH: %containSRCH%

ECHO.%containVARB% | FIND /I %containSRCH%>Nul && (
  exit /b 1
) || (
  exit /b 0
)
