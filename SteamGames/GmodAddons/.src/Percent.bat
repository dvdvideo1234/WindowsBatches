@echo off

set /a "perFRAC=%1"
set /a "perALLV=%2"
set /a "perOUTP=0"

set /a "perOUTP=(%perFRAC% * 100) / %perALLV%"

set /a "%~3=%perOUTP%"
