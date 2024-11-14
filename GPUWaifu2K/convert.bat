@echo off

setlocal EnableDelayedExpansion

:: https://github.com/nihui/waifu2x-ncnn-vulkan
:: -h                   show this help
:: -v                   verbose output
:: -i input-path        input image path (jpg/png/webp) or directory
:: -o output-path       output image path (jpg/png/webp) or directory
:: -n noise-level       denoise level (-1/0/1/2/3, default=0)
:: -s scale             upscale ratio (1/2/4/8/16/32, default=2)
:: -t tile-size         tile size (>=32/0=auto, default=0) can be 0,0,0 for multi-gpu
:: -m model-path        waifu2x model path (default=models-cunet)
:: -g gpu-id            gpu device to use (-1=cpu, default=auto) can be 0,1,2 for multi-gpu
:: -j load:proc:save    thread count for load/proc/save (default=1:2:2) can be 1:2,2,2:2 for multi-gpu
:: -x                   enable tta mode
:: -f format            output image format (jpg/png/webp, default=ext/png)

:: https://github.com/BtbN/FFmpeg-Builds/releases
:: -compression_level Values in [0,12]  (Higher is greater quality is reduced)
:: -quality           Values in [0,100] (Higher is better)

:: Manual FFMpeg

set "waifuFFMpg=D:\Programs\FFmpeg\bin"
set "waifuFFCom=0"
set "waifuQualy=100"

:: Manual Waifu2X

set "waifuBase=D:\Programs\waifu2x-ncnn-vulkan"
set "waifuExec=waifu2x-ncnn-vulkan"
set "waifuTemp=TEMP"
set "waifuNoise=1"
set "waifuScale=4"
set "waifuTile=256"
set "waifuOutFmt=jpg"
set "waifuModel=cunet"
set "waifuGPUID=0"

:: Automatic ( Dont touch )
set "waifuLogs=waifu.log"
set "waifuFile=%1"
set "waifuConv=%2"
set "waifuWait=%3"
set "waifuCurr=%~dp0"
set "waifuExtIMG=%~x1"
set "waifuExtOUT=.jpg"
set "waifuFrmOUT=-update true -frames:v 1 -map 0:v:0"

cd /d %waifuCurr%

echo Directory: %waifuCurr%
echo WARNING: Do not push Ctrl+C while the image PREVIEW is opened^^!

if not defined waifuWait (
  set "waifuWait=Y"
)

if not defined waifuConv (
  echo Undefined count... Using [1]^^!
  set /a "waifuConv=1"
)

if /I !waifuConv! LEQ 0 (
  echo Mismatch count... Using [1]^^!
  set /a "waifuConv=1"
) else (
  echo Arithmetic count... Using [!waifuConv!]^^!
  set /a "waifuConv=!waifuConv!"
)

if %waifuConv% EQU 1 (
  echo From: %waifuFile%
  echo Dest: out%waifuExtIMG%
  if %waifuScale% EQU 1 (
    call copy /v /y "%waifuFile%" "out%waifuExtIMG%" >nul || (
      echo Data copy failed at iteration [0]^^!
      exit /B 1
    )
  ) else (
    call %waifuBase%\%waifuExec%.exe -v -f %waifuOutFmt% -i %waifuFile% -o out%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>>&1 || (
      echo Upscaler failed at iteration [0]^^!
      exit /B 1
    )
  )
) else (
  if not exist %waifuTemp% mkdir %waifuTemp%

  set /a "waifuCnt1=1"
  set /a "waifuCnt2=2"

  call %waifuBase%\%waifuExec%.exe -v -f %waifuOutFmt% -i %waifuFile% -o %waifuCurr%%waifuTemp%\1%waifuExtIMG% -m models-%waifuModel% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1> %waifuLogs% 2>>&1 || (
    echo Upscaler failed at iteration [!waifuCnt1!]^^!
    exit /B 1
  )
  if defined waifuFFMpg (
    echo %waifuFFMpg%\ffmpeg.exe -y -i %waifuCurr%%waifuTemp%\1%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% %waifuCurr%%waifuTemp%\1_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1
    call %waifuFFMpg%\ffmpeg.exe -y -i %waifuCurr%%waifuTemp%\1%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% %waifuCurr%%waifuTemp%\1_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1 && (
      call :waifuGetRatio %waifuCurr%%waifuTemp%\1%waifuExtIMG% %waifuCurr%%waifuTemp%\1_f%waifuExtOUT%
      echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
    ) || (
      echo FFMpeg failed at iteration [!waifuCnt1!]!
      exit /B 2
    )
  )

  for /l %%k in (2, 1, %waifuConv%) do (
    echo From: !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG%
    echo Dest: !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG%
    call %waifuBase%\%waifuExec%.exe -v -f %waifuOutFmt% -i !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% -m models-%waifuModel% -o !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -n %waifuNoise% -s %waifuScale% -t %waifuTile% -g %waifuGPUID% 1>> %waifuLogs% 2>>&1 || (
      echo Upscaler failed at iteration [!waifuCnt1!]^^!
      exit /B 1
    )
    if defined waifuFFMpg (
      echo %waifuFFMpg%\ffmpeg.exe -y -i !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1
      call %waifuFFMpg%\ffmpeg.exe -y -i !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1 && (
        call :waifuGetRatio !waifuCurr!!waifuTemp!\!waifuCnt2!%waifuExtIMG% !waifuCurr!!waifuTemp!\!waifuCnt2!_f%waifuExtOUT%
        echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
      ) || (
        echo FFMpeg failed at iteration [!waifuCnt1!]!
        exit /B 2
      )
    )
    set /a "waifuCnt1+=1"
    set /a "waifuCnt2+=1"
  )

  copy /v !waifuCurr!!waifuTemp!\!waifuCnt1!%waifuExtIMG% %waifuCurr%\out%waifuExtIMG%
)

if defined waifuFFMpg (
  echo %waifuFFMpg%\ffmpeg.exe -y -i out%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% out_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1
  call %waifuFFMpg%\ffmpeg.exe -y -i out%waifuExtIMG% -compression_level %waifuFFCom% -quality %waifuQualy% %waifuFrmOUT% out_f%waifuExtOUT% 1>> %waifuLogs% 2>>&1 && (
    call :waifuGetRatio out%waifuExtIMG% out_f%waifuExtOUT%
    echo FFMpeg... Output size is !waifuRatio!%% of input size^^!
  ) || (
    echo FFMpeg failed at final iteration^^!
    exit /B 2
  )
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
