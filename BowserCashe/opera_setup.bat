md "K:\CACHEFILES"

md "K:\CACHEFILES\OPERA"
md "K:\CACHEFILES\OPERAGX"

mklink /d "C:\Users\%1\AppData\Local\Opera Software\Opera Stable" "K:\CACHEFILES\OPERA"
mklink /d "C:\Users\%1\AppData\Local\Opera Software\Opera GX Stable" "K:\CACHEFILES\OPERAGX"
