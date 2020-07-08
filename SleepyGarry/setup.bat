@echo off

echo Hide me, sleepy Garry! I don't want one of
echo these below to wake me from this dream!
echo.

powercfg /? > powercfg.txt

powercfg -devicequery wake_armed
