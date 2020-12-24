### Description
This automatically setups your `Windows 7` login screen background image!

### Requirements
1. Image extension must be `*.jpg`
2. Image size must be less than `250KB`

### Install
1. Bring up an elevated rights command prompt via `Start` > `cmd` > `Right Click` > `Run as Administrator`
2. Navigate to where you've stored the script. Mine is `E:\GIT\WindowsBatches\ChangeBackground`
3. Evaluate `E:\GIT\WindowsBatches\ChangeBackground>change.bat image.jpg`
4. Answer `y` to `Apply picture change [y/N] ?` for replacing or updating the image file
5. Answer `y` to `Enable custom background [y/N] ?` for enabling `OEM` background in the registry

**Note: When you answer the second question with `n` you will disable the `OEM` background!**

### Examples
Check out the following example applied on my personal machine at home
```
E:\GIT\WindowsBatches\ChangeBackground>dir
 Volume in drive E is Backup
 Volume Serial Number is 18C2-B495

 Directory of E:\GIT\WindowsBatches\ChangeBackground

2020-12-23  20:59    <DIR>          .
2020-12-23  20:59    <DIR>          ..
2020-12-23  20:52             2 235 change.bat
2020-03-27  12:28           149 717 image.jpg
2020-12-23  21:07               733 readme.md
               3 File(s)        152 685 bytes
               2 Dir(s)  514 980 126 720 bytes free

E:\GIT\WindowsBatches\ChangeBackground>change.bat image.jpg
Running: Microsoft Windows 7 Ultimate 6.1.7601
Apply picture change [y/N] ? y
Background image will be changed to [image.jpg]!
E:\GIT\WindowsBatches\ChangeBackground\image.jpg -> C:\Windows\System32\oobe\inf
o\backgrounds\backgroundDefault.jpg
1 File(s) copied
Enable custom background [y/N] ? y
The operation completed successfully.

Waiting for 498 seconds, press a key to continue ...

E:\GIT\WindowsBatches\ChangeBackground>
```
