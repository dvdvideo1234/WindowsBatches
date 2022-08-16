### Creating a RAM disk [ImDisk][imdisk]
```
imdisk -a -s 512M -m X: -p "/fs:ntfs /q /y"
```
 * -a initializes the virtual disk.
 * -s `512M` is the size, `512` MegaBytes.
    The full choices are `b`, `k`, `m`, `g`, `t`, `K`, `M`, `G`, or `T`.
    These denote a number of `512`-byte blocks, thousand bytes, million bytes,
    billion bytes, trillion bytes, `KB`, `MB`, `GB`, and `TB`, respectively.
 * -m X
    Sets up the mount point a.k.a. the drive letter, `X:`.
 * -p "fs:ntfs /q /y" formats the drive.
    Parameters are actually for Windows' format program.
    If you want the RAM disk in a different filesystem,
    just change ntfs to `fat` (FAT16) or `fat32` (FAT32).

After you run that command, you should be able to see it with Windows Explorer,
formatted and ready to be used. Any additional disks can be made by simply changing
-m's parameter to another letter, changing the size & filesystem parameters if you
want to, and run it again.

### Deleting a RAM disk [ImDisk](http://www.ltr-data.se/opencode.html/#ImDisk)

```
imdisk -d -m X:
imdisk -D -m X:
```
Second option forces a removal. Of course X: is the drive letter of the RAM disk
you want to `detach/delete/remove`. Setting up RAM disk(s) automatically when Windows
starts. The surefire way to do this without using Group Policy Editor (`gpedit.msc`,
which only exists in Professional version and up) is to define a task in Task Scheduler (`taskschd.msc`).
As usual, Start Menu's search box should make it easy to find and start Task Scheduler.
But before creating a schedule, it's advisable to create a command script first a.k.a.
`.cmd` file, especially if we're going to start multiple RAM disks.
For example, we want to create 3 RAM disks with drive letters `X:`, `Y:`, and `Z:`.
`X:` is `1GB` in `NTFS`, `Y:` is `256MB` in `FAT16`, and `Z:` `is` 768MB in `FAT32`.
```
imdisk -a -s 1G -m X: -p "/fs:ntfs /q /y"
imdisk -a -s 256M -m Y: -p "/fs:fat /q /y"
imdisk -a -s 768M -m Z: -p "/fs:fat32 /q /y"
```
Save it as `start-im-disk` with `cmd` or `bat` exension, or any other name.
Personally, I'd save the file inside a directory I created under `C:` or
system drive `C:\ImDisk\`. When that is done, let's go back to Task Scheduler.

### Import dedicated task

Using the left-most pane, browse to `Task Scheduler Library` `->` `Microsoft`
`->` `Windows`. Right-click on the upper middle pane (which is usually empty)
and `Import Task...` then give it the one in the repo [`start-ramdisk-task.xml`][task]

### Adding the page on the RAM drive

We need to go back to the website where we downloaded [ImDisk][imdisk], but to its
command-line utilities section. Look for `swapadd.zip`, and download that.
Extract the content to `C:\Windows\System32\` to make things easier.
Say we want to have 1GB of RAM disk dedicated for a page file formatted in NTFS assigned to W:.
```
imdisk -a -s 1G -m W: -p "/fs:ntfs /q /y"
swapadd W:\pagefile.sys 990M 990M
```
First line, by now, is self-explanatory. The second line is basically adding `pagefile.sys`
to the RAM disk in W:, sized `990MB`. The first `990M` is the minimum size, or lower limit.
The second is the maximum size for the page file. When you set both to the same number, it
sets a page file with a static size. Similar to `imdisk`, you can set the size to `KB`, `MB`,
or `GB`, by using `K`, `M`, or `G` after the number, respectively.

### Setting a persistent RAM disk across restarts and shutdowns

Now, what if we want to set a RAM disk as a browser cache, but we don't want it getting
'reset' every time we start Windows? Or maybe even our account's temporary folder
(which is different from Windows' temporary folder)? As before, we need to visit [here][imdisk] again.
Look for `rawcopy.zip`, and extract its content to `C:\Windows\System32\` directory.
Now, for this, we need to create both a new `.cmd` file and a new schedule.
This is because we need to run the command(s) when Windows is shutting down in
order to `restart` or `shutdown`, which requires a separate schedule along with a different trigger.
```
rawcopy -mld \\.\Y: "C:\RAM disks\Y.img"
rawcopy -mld \\.\Z: "C:\RAM disks\Z.img"
```
Save it as, for example, `imdisk-save.cmd`. You can save it in the same directory as where
you've saved `imdisk-start.cmd`. As for the parameters, you only need to understand the last two:
  1. `\\.\Z:` The drive letter of the RAM disk which contents we want to preserve.
  2. `C:\RAM disks\Z.img` Means that rawcopy will write the image file named `Z.img` in a directory called `C:\RAM disks\`.
Next, setting up the schedule. Aside from the schedule name (I named mine 'ImDisk Save'), the steps
and settings are similar to when we created the schedule for starting the RAM disks.
Except that at :

1. Triggers.. Click New....
  * On Begin the task:, choose On an event.
2. Settings
 * On Log:, choose System.
 * On Source:, choose USER32.
 * On Event ID:, type 1074.
3. Actions.. Click New.... Click Browse....
 * Look for the .cmd file you created earlier to save the RAM disks; i.e `imdisk-save.cmd`.
 * Double-click the file, then click OK.?
4. Settings
 * Turn off If the running task does not end when requested, force it to stop.
 * Don't forget turn on Run task as soon as possible after a scheduled start is missed.
 * Click OK to create the new schedule, and that's it.

If you're wondering why the trigger is like that, open up Event Viewer (`eventvwr.msc`).
Navigate to `Windows Logs` -> `System`, then look for events with the source `USER32`.
And the reason we need to turn off `If the running task does not end when requested, force it to stop`
option is to prevent Windows from prematurely ending `imdisk-save.cmd`, which could make rawcopy
stopping halfway or not starting at all.
Lastly, we need to edit the imdisk-start.cmd file again.
Replace these lines :
```
imdisk -a -s 256M -m Y: -p "/fs:fat /q /y"
imdisk -a -s 768M -m Z: -p "/fs:fat32 /q /y"
```
With these :
```
imdisk -a -t vm -f "C:\RAM disks\Y.img" -m Y:
imdisk -a -t vm -f "C:\RAM disks\Z.img" -m Z:
```
The new codes are basically telling imdisk to make RAM disks using the image
files that were saved when Windows was shutting down. Of course, the directory
and image file names should be according to what you've set in imdisk-save.cmd before.

[task]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/start-ramdisk-task.xml
[imdisk]: http://www.ltr-data.se/opencode.html/#ImDisk
