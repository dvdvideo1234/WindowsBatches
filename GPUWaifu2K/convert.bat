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
set "waifuFFCom=0"
set "waifuQualy=100"

:: Manual Waifu2X

set "waifuBase=D:\waifu2x-ncnn-vulkan"
set "waifuExec=waifu2x-ncnn-vulkan"
set "waifuTemp=TEMP"
set "waifuNoise=3"
set "waifuScale=2"
set "waifuTile=32"
set "waifuModel=upconv_7_anime_style_art_rgb"
set "waifuGPUID=0"

:: Automatic ( Dont touch )
set "waifuLogs=waifu.log"
set "waifuFile=%1"
set /a "waifuConv=%2"
set "waifuWait=%3"
set "waifuCurr=%~dp0"
set "waifuExtIMG=%~x1"

cd /d %waifuCurr%

echo Directory: %waifuCurr%
echo WARNING: Do not push Ctrl+C while the image PREVIEW is opened^^!

if not defined waifuWait (
  set "waifuWait=Y"
)

if not defined waifuConv (
  echo Conversion stage [%waifuConv%]^^!
  set /a "waifuConv=1"
  echo Not defined using [1] instead^^!
)

if /I "%waifuConv%" LEQ "0" (
  echo Conversion stage [%waifuConv%]^^!
  set /a "waifuConv=1"
  echo Mismatch using [1] instead^^!
)

if %waifuConv% equ 1 (
  %waifuBase%\%waifuExec%.exe -v -i %waifuFile% -o out%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>>&1
) else (
  if not exist %waifuTemp% mkdir %waifuTemp%

  set /a "waifuCnt1=1"
  set /a "waifuCnt2=2"

  %waifuBase%\%waifuExec%.exe -v -i %waifuFile% -o %waifuCurr%%waifuTemp%\1%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>>&1

  if defined waifuFFMpg (
    echo %waifuFFMpg%\ffmpeg.exe -y -i %waifuCurr%%waifuTemp%\1%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuCurr%%waifuTemp%\1_f%waifuExtIMG% 1>> %waifuLogs% 2>>&1
    %waifuFFMpg%\ffmpeg.exe -y -i %waifuCurr%%waifuTemp%\1%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuCurr%%waifuTemp%\1_f%waifuExtIMG% 1>> %waifuLogs% 2>>&1
    call :waifuGetRatio %waifuCurr%%waifuTemp%\1%waifuExtIMG% %waifuCurr%%waifuTemp%\1_f%waifuExtIMG%
    echo.
    echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
  )

  for /l %%k in (2, 1, %waifuConv%) do (
    echo.
    echo From: !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG%
    echo Dest: !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG%
    %waifuBase%\%waifuExec%.exe -v -i !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% -m models-%waifuModel% -o !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1>> %waifuLogs% 2>>&1

    if defined waifuFFMpg (
      echo %waifuFFMpg%\ffmpeg.exe -y -i !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtIMG%  1>> %waifuLogs% 2>>&1
      %waifuFFMpg%\ffmpeg.exe -y -i !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtIMG% 1>> %waifuLogs% 2>>&1
      call :waifuGetRatio !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtIMG%
      echo.
      echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
    )

    set /a "waifuCnt1+=1"
    set /a "waifuCnt2+=1"
  )

  copy /v !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% %waifuCurr%\out%waifuExtIMG%
)

if defined waifuFFMpg (
  echo %waifuFFMpg%\ffmpeg.exe -y -i out%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% out_f%waifuExtIMG% 1>> %waifuLogs% 2>>&1
  %waifuFFMpg%\ffmpeg.exe -y -i out%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% out_f%waifuExtIMG% 1>> %waifuLogs% 2>>&1
  call :waifuGetRatio out%waifuExtIMG% out_f%waifuExtIMG%
  echo.
  echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
)

if /I "%waifuWait%" EQU "y" (
  timeout 100
) else (
  if /I "%waifuWait%" EQU "Y" (
    timeout 100
  )
)

:: Functions

goto :eof

:waifuGetRatio
set /A waifuRatio=0
set /A "waifuRatio=%~z2*100"
set /A "waifuRatio/=%~z1"

goto :eof
