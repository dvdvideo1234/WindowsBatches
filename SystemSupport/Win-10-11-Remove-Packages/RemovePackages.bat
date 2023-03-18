@echo off

for /F "delims==" %%k in ('dir *.ps1 /b /s') do (
  echo Running: %%k...
  call powershell -file "%%k"
)

timeout 300


