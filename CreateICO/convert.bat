@echo off 

setlocal enableDelayedExpansion

:: Requires
:: 1. https://github.com/BtbN/FFmpeg-Builds/releases
:: 2. https://imagemagick.org/index.php

set "icoFFMPEG=C:\Programs\ffmpeg-master-latest-win64-gpl\bin"
set "icoMAGIC=C:\Program Files\ImageMagick-HDRI"

set "icoLOGS=ico.log"
set "icoCURR=%~dp0"
set "icoEXT=%~x1"
set "icoNAME=%~n1"
set "icoTEMP=TEMP"
set "icoFFCOM=0"
set "icoQUALY=100"

set icoSizes[0]=16
set icoSizes[1]=32
set icoSizes[2]=48
set icoSizes[3]=64
set icoSizes[4]=72
set icoSizes[5]=96
set icoSizes[6]=128
set icoSizes[7]=256
set "icoSets="

if not exist %icoTEMP% mkdir %icoTEMP%

for /L %%i in (0,1,7) do (
  echo %icoFFMPEG%\ffmpeg.exe -y -i !icoCURR!%1 -vf scale=!icoSizes[%%i]!:!icoSizes[%%i]! -compression_level %icoFFCOM% -quality %icoQUALY% !icoCURR!%icoTEMP%\!icoSizes[%%i]!!icoEXT! 1>> %icoLOGS% 2>>&1
  call %icoFFMPEG%\ffmpeg.exe -y -i !icoCURR!%1 -vf scale=!icoSizes[%%i]!:!icoSizes[%%i]! -compression_level %icoFFCOM% -quality %icoQUALY% !icoCURR!%icoTEMP%\!icoSizes[%%i]!!icoEXT! 1>> %icoLOGS% 2>>&1 && (
    call :waifuGetRatio !icoCURR!%1 !icoCURR!%icoTEMP%\!icoSizes[%%i]!!icoEXT!
    echo.
    echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
  ) || (
    echo FFMpeg failed at final iteration^^!
    exit /B 2
  )
  set "icoSets=!icoSets! !icoSizes[%%i]!!icoEXT!"
)

:: Convert PNG-s to an icon
cd /d !icoCURR!%icoTEMP%
call "!icoMAGIC!\convert.exe" !icoSets! -colors 256 !icoNAME!.ico
cd !icoCURR!

:: Generate autorun
if not exist %icoNAME% mkdir %icoNAME%
cd !icoCURR!%icoNAME%

call copy /d /y !icoCURR!%icoTEMP%\!icoNAME!.ico drive.ico

echo ; Created by DVD's Windows Batches > autorun.inf
echo ; https://github.com/dvdvideo1234/WindowsBatches >> autorun.inf
echo [autorun] >> autorun.inf
echo icon = drive.ico >> autorun.inf

cd /d !icoCURR!

:: Functions

goto :eof

:waifuGetRatio
set /A waifuRatio=0
set /A "waifuRatio=%~z2*100"
set /A "waifuRatio/=%~z1"

goto :eof


