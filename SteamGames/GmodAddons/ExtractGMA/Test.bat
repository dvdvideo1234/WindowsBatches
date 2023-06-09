@echo off

setlocal EnableDelayedExpansion

call .src\Contain.bat "C:\Users\ddobromirov\Documents\Lua-Projs\VerControl\WindowsBatches\SteamGames\GmodAddons\ExtractGMA\data\process - copy.gma" "process - copy.gma"

if !ERRORLEVEL! EQU 1 (
  echo YES
) else (
  echo NO
)

call .src\Contain.bat "C:\Users\ddobromirov\Documents\Lua-Projs\VerControl\WindowsBatches\SteamGames\GmodAddons\ExtractGMA\data\process.gma" "process - copy.gma"

if !ERRORLEVEL! EQU 1 (
  echo YES
) else (
  echo NO
)
