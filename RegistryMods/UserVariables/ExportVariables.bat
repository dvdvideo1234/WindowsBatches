@echo off

set "EXPORT_PWD=%~dp0"
set "EXPORT_REG=HKEY_CURRENT_USER\Environment"

reg import %EXPORT_PWD%\UserVariables.reg

for /F "Tokens=1,2*" %%A in ('reg query %EXPORT_REG%') do (
  If "%%B" neq "" setx "%%A" "%%C"
)