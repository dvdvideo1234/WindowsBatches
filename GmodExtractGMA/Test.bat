@echo off

:: Enable delayed expression for use of aritmetic stuff

setlocal EnableDelayedExpansion

:: The user configures the following

set "testVar=E:\GIT\WindowsBatches\GmodExtractGMA\DATA\ashland_%%&_olive_hill__%%(in-dev%%)_1469532899.gma"
set "testFnd=1469532899"
:: The rest of the file is automatic

set "testExt=%~x1"

call Contain.bat !testVar! !testFnd!
IF !ERRORLEVEL! EQU 1 (
  echo FOUND
) else (
  echo NOT FOUND
)
