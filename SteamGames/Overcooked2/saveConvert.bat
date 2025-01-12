@echo off

setlocal EnableDelayedExpansion

set "overIDO=76561198059614197"
set "overIDN=76561197988124141"
set "overDest=crypt"
set "overBase=%~dp0"
set "overTool=OvercookedTool"

:: .\OvercookedTool.exe decrypt C:\Users\Foo\AppData\LocalLow\Team17\Overcooked2\12345678912345679\Meta_SaveFile.save C:\Temp\Meta_SaveFile.json 12345678912345679
:: .\OvercookedTool.exe encrypt C:\Temp\Meta_SaveFile.json C:\Users\Foo\AppData\LocalLow\Team17\Overcooked2\Saves\987654321987654321\Meta_SaveFile.save 987654321987654321

if exist "!overBase!\!overDest!" rd /S /Q "!overBase!\!overDest!"

md "!overBase!\!overDest!"

if exist "!overBase!\Team17\Overcooked2\!overIDO!" (
  echo Processing Ovecooked 2...
  call !overBase!\!overTool!\OvercookedTool.exe decrypt "!overBase!\Team17\Overcooked2\!overIDO!\Meta_SaveFile.save" "!overBase!\!overDest!\Meta_SaveFile.json" !overIDO!
  call !overBase!\!overTool!\OvercookedTool.exe encrypt "!overBase!\!overDest!\Meta_SaveFile.json" "!overBase!\!overDest!\Meta_SaveFile.save" !overIDN!
)