@echo off
:: ========================
:: file build.bat
:: ========================
setlocal

:: You may change the following variable's value
:: to suit the downloaded version
set lua_version=5.4.4

:: Install folder of the 7z archiver
set "folder_7z=%ZIP7_HOME%"

:: Path to an active MinGW executable
set "migw_dir=%MING_HOME%\bin"
set work_dir=%~dp0

:: Removes trailing backslash
set work_dir=%work_dir:~0,-1%
set lua_install_dir=%work_dir%\lua
set compiler_bin_dir=%work_dir%\tdm-gcc\bin
set lua_build_dir=%work_dir%\lua-%lua_version%
set path=%compiler_bin_dir%;%path%

:: Cleaning up before run

:: Download Lua archive by using CodeBlocks MinGW web-get
call "%GIT_HOME%\bin\wget.exe" https://www.lua.org/ftp/lua-%lua_version%.tar.gz

:: Extract Lua source with 7z
call "%folder_7z%\7z.exe" x lua-%lua_version%.tar.gz -aoa
call "%folder_7z%\7z.exe" x -ttar lua-%lua_version%.tar -aoa
del lua*.tar 

:: Build the language
:: When compilation fails make sure MinGW is added to <Path>
cd /D "%lua_build_dir%"
call "%migw_dir%\mingw32-make.exe" PLAT=mingw

echo.
echo **** COMPILATION TERMINATED ****
echo.
echo **** BUILDING BINARY DISTRIBUTION ****
echo.

:: Create a clean "binary" installation
mkdir "%lua_install_dir%"
mkdir "%lua_install_dir%\doc"
mkdir "%lua_install_dir%\bin"
mkdir "%lua_install_dir%\include"

copy "%lua_build_dir%\doc\*.*" "%lua_install_dir%\doc\*.*"
copy "%lua_build_dir%\src\*.exe" "%lua_install_dir%\bin\*.*"
copy "%lua_build_dir%\src\*.dll" "%lua_install_dir%\bin\*.*"
copy "%lua_build_dir%\src\luaconf.h" "%lua_install_dir%\include\*.*"
copy "%lua_build_dir%\src\lua.h" "%lua_install_dir%\include\*.*"
copy "%lua_build_dir%\src\lualib.h" "%lua_install_dir%\include\*.*"
copy "%lua_build_dir%\src\lauxlib.h" "%lua_install_dir%\include\*.*"
copy "%lua_build_dir%\src\lua.hpp" "%lua_install_dir%\include\*.*"

echo.
echo **** BINARY DISTRIBUTION BUILT ****
echo.

"%lua_install_dir%\bin\lua.exe" -e"print [[Hello!]];print[[Simple Lua test successful!!!]]"

echo.

pause
