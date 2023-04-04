@echo off

call powershell -ExecutionPolicy Bypass -file "CurrentPackages.ps1"

for /F "delims==" %%k in ('dir *.ps1 /b /s') do (
  echo Running: %%k...
  call powershell  -ExecutionPolicy Bypass -file "%%k"
)

timeout 300
