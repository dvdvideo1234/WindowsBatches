### Relocate opera cache

1. Opera does not have GUI relacation so we use [mklink][ref-mklink]
2. Find the username for the opera browser
  * Try printing it via [echo][ref-echo] `echo %USERNAME%`
  * Try calling [Jakie Chan][ref-imdb] to [spell it for you][ref-whoami]
  * Try printing via [echo][ref-echo] user profile `echo %USERPROFILE%`
3. For me this will return `DVD` or `dvd-pc\dvd` for example. **Yours is different**!
2. After the RAM drive folder is created run
  * Opera: `mklink /d "C:\Users\<USER>\AppData\Local\Opera Software\Opera Stable" "R:\CACHEFILES\OPERA"`
  * Opera GX: `mklink /d "C:\Users\<USER>\AppData\Local\Opera Software\Opera GX Stable" "R:\CACHEFILES\OPERAGX"`
3. Start the browser and make sure the cashe goes to the folders specified

[ref-mklink]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mklink
[ref-echo]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/echo
[ref-whoami]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/whoami
[ref-imdb]: https://www.imdb.com/title/tt0127357/
