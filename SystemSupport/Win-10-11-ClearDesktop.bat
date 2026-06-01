@echo off

setlocal EnableDelayedExpansion

set "RM_EXT_TEXT=txt c cpp h pc pcs pck bak xml html har lua"
set "RM_EXT_WORD=xls xlsx doc docx ppt pptx rtf msg"
set "RM_EXT_IMAG=bmp jpg jpeg png webp gif"
set "RM_EXT_DATA=csv sql log"
set "RM_EXT_FILE=zip cia rar 7z arj md"
set "RM_EXT_APPS=exe bin"
set "RM_EXT_GITS=gitattributes gitignore"

for %%C in (TEXT WORD IMAG DATA FILE APPS GITS) do (
  set "RM_EXT_LST=!RM_EXT_%%C!"
  echo Remove [%%C] : !RM_EXT_LST!

  for %%E in (!RM_EXT_LST!) do (
    del /q *.%%E 2>nul >nul
    del /q *.~%%E 2>nul >nul
  )
)
