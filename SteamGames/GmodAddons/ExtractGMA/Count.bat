attrib.exe /s %~f1/*.gma | find /v "File not found - " | find /c /v ""
