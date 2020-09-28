@echo off

setlocal EnableDelayedExpansion

:: https://github.com/nihui/waifu2x-ncnn-vulkan
:: -h                   show this help
:: -v                   verbose output
:: -i input-path        input image path (jpg/png/webp) or directory
:: -o output-path       output image path (jpg/png/webp) or directory
:: -n noise-level       denoise level (-1/0/1/2/3, default=0)
:: -s scale             upscale ratio (1/2, default=2)
:: -t tile-size         tile size (>=32/0=auto, default=0) can be 0,0,0 for multi-gpu
:: -m model-path        waifu2x model path (default=models-cunet)
:: -g gpu-id            gpu device to use (default=0) can be 0,1,2 for multi-gpu
:: -j load:proc:save    thread count for load/proc/save (default=1:2:2) can be 1:2,2,2:2 for multi-gpu
:: -x                   enable tta mode
:: -f format            output image format (jpg/png/webp, default=ext/png)

:: https://github.com/BtbN/FFmpeg-Builds/releases
:: -compression_level Values in [0,12]  (Higher is greater quality is reduced)
:: -quality           Values in [0,100] (Higher is better)

:: Manual FFMpeg

set "waifuFFMpg=D:\FFmpeg\bin"
set "waifuFFCom=2"
set "waifuQualy=100"

:: Manual Waifu2X

set "waifuBase=D:\waifu2x-ncnn-vulkan"
set "waifuExec=waifu2x-ncnn-vulkan"
set "waifuTemp=TEMP"
set "waifuNoise=2"
set "waifuScale=2"
set "waifuTile=128"
set "waifuModel=cunet"
set "waifuGPUID=0"

:: Automatic ( Dont touch )
set "waifuLogs=waifu.log"
set "waifuFile=%1"
set "waifuConv=%2"
set "waifuCurr=%~dp0"
set "waifuExtIMG=%~x1"

cd /d %waifuCurr%

echo Directory: %waifuCurr%

if "%waifuConv%" leq "" (
  set /a "waifuConv=1"
)

if %waifuConv% leq 1 (
  set /a "waifuConv=1"
)

if %waifuConv% equ 1 (
  %waifuBase%\%waifuExec%.exe -v -i %waifuFile% -o out%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>&1
) else (
  if not exist %waifuTemp% mkdir %waifuTemp%

  set /a "waifuCnt1=1"
  set /a "waifuCnt2=2"
  
  %waifuBase%\%waifuExec%.exe -v -i %waifuFile% -o %waifuCurr%%waifuTemp%\1%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>&1
  
  for /l %%k in (2, 1, %waifuConv%) do (
    echo.
    echo From: !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG%
    echo Dest: !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG%
    %waifuBase%\%waifuExec%.exe -v -i !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% -m models-%waifuModel% -o !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1>> %waifuLogs% 2>>&1

    set /a "waifuCnt1+=1"
    set /a "waifuCnt2+=1"
  )
  
  copy /v !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% %waifuCurr%\out%waifuExtIMG%
)

if defined waifuFFMpg (
  %waifuFFMpg%\ffmpeg.exe -y -i out%waifuExtIMG% -compression_level %waifuFFCom% out_%waifuFFCom%%waifuExtIMG% 1>> %waifuLogs% 2>>&1
  call :waifuGetRatio %waifuFile% out_%waifuFFCom%%waifuExtIMG%
  echo.
  echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
)

timeout 100

goto :eof

:: Functions

:waifuGetRatio
echo %1 %~z1
echo %2 %~z2
set /A waifuRatio=0
set /A "waifuRatio=%~z2*100"
set /A "waifuRatio/=%~z1"
goto :eof
