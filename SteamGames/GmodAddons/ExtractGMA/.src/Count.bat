@echo off

attrib.exe /s %~f1/*.%2 | find /v "File not found - " | find /c /v ""
