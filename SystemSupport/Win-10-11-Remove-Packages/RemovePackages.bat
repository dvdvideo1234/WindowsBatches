@echo off

set "removePath=%~dp0"

call powershell -ExecutionPolicy Bypass -file "%removePath%CurrentPackages.ps1"

for /F "delims==" %%k in ('dir %removePath%*.ps1 /b /s') do (
  echo Running: %%k...
  call powershell  -ExecutionPolicy Bypass -file "%%k"
)

timeout 300
