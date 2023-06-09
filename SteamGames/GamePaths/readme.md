### Description
This section is used for configuring various [steam][ref-steam] applications
that are installed on a drive different than `C:\`, but requite files
or directories from the [steam][ref-steam] app installation. They fix the most
common problems of applications not running due to being located on
another drive rather than `C:\`

### No, thanks! I'll just move my files to `C:\`!
![](https://i.pinimg.com/originals/c4/07/40/c4074087283441de471b78e0fb56cf25.gif)

### Yes, Steam libraries do not belong to `C:\` in the first place!
![](https://media.tenor.com/9MEq92i7JxUAAAAd/echidna-tea-time.gif)

### My game wants steam.exe in its main folder. WTH!
Some games are buggy ( Yes, I am talking to you Rockstar ).
They require you to have [`steam.exe`][ref-steam] in the same folder as
the game executable ( Yes, exactly you, GTA3 ). To trick it:
1. Copy [`Steam_Make_MKLink.bat`][ref-game] to the game's main folder
2. Start the `BAT` file and create link pointing to [`steam.exe`][ref-steam]
3. Start your game play and have fun!

### I have installed a Half-Life2 mod, but I don't see it in the games list
Ah, yes. This is a limitation to the source engine file structure.
This requires the mod to be installed on the [steam][ref-steam] drive so the app can see it.
Please take a note that the `sourcemods` folder must be deleted so back it up!
Let's say you want `sourcemods` to be located in `D:\Steam\steamapps\sourcemods`
1. Back up the `sourcemods` folder to your desired location `D:\Steam\steamapps\sourcemods`
2. Download and run [`Steam_SourceMods_MKLink.bat "D:\Steam\steamapps\sourcemods"`][ref-mods]
3. The script will delete the empty `sourcemods` folder and link it to the new location

[ref-steam]: https://steamcommunity.com/
[ref-game]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/SteamGamesFix/Steam_Make_MKLink.bat
[ref-mods]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/SteamGamesFix/Steam_SourceMods_MKLink.bat
