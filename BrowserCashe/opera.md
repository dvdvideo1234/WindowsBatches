### Relocate opera cache

1. Opera does not have GUI relacation so we use [mklink][mklink]
2. Find the username for the opera browser
  * Try [echo-ing][echo] it via `echo %USERNAME%`
  * Try calling [Jakie Chan][imdb] to [spell it for you][whoami] ;)
  * Try [echo-ing][echo] the user profile `echo %USERPROFILE%`
3. This will return `DVD` or `dvd-pc\dvd` for example
2. After the RAM drive folder is created run
  * Opera: `mklink /d "C:\Users\<USER>\AppData\Local\Opera Software\Opera Stable" "R:\CACHEFILES\OPERA"`
  * Opera GX: `mklink /d "C:\Users\<USER>\AppData\Local\Opera Software\Opera GX Stable" "R:\CACHEFILES\OPERAGX"`
3. Start the browser and make sure the chace goes to the folders specified

[mklink]: (https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mklink)
[echo]: (https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/echo)
[whoami]: (https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/whoami)
[imdb]: (https://www.imdb.com/title/tt0127357/)
