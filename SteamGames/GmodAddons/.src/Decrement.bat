@echo off

set /a "perINPS=%1"
set /a "perOUTP=0"

set /a "perOUTP=%perINPS% - 1"

set /a "%~2=%perOUTP%"
