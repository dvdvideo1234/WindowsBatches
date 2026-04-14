@echo off

setlocal EnableDelayedExpansion

echo Param: %*

set "arrSrc=%1"
set /A "arrCnt=0"
set arrData=()

for /F %%a in (!arrSrc!) do (
   set /A "arrCnt=!arrCnt! + 1"
   set arrData[!arrCnt!]=%%a
   set "%~3[!arrCnt!]=%%a"
)

for /L %%i in (1,1,!arrCnt!) do echo Intest [%%i]: !arrData[%%i]!

echo Intest 1: !arrCnt!

set /a "%~2=!arrCnt!"

endlocal
