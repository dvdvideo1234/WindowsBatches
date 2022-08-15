### Description
This will guide you to relocate your browser cache to a ram drive.
Its main purpose is to save your SSD write cycles and make it live
a healthy long life and serve you well. This guide uses [ImDisk][imdisk]!

### Installation
1. Install [ImDisk][git-im-disk] so you have the command `imdisk` available. [Arsenal][git-im-disk] may be better.
2. Copy [`start-im-disk.bat`][disk-start] and [`create-folders.bat`][make-folders] to `C:\`
3. Open the `Task Scheduler` and import the system task [`start-ramdisk-task.xml`][sys-task]

### Browsers information
Specific browser information can be located in the `*.md` files in this repo.
 * [`Mozilla Firefox`][in-ff]
 * [`Google Chrome`][in-gc]
 * [`Opera`][in-op]
 * [`Microsoft Edge`][in-eg]
 * [`Internet Explorer`][in-ie]

[imdisk]: http://www.ltr-data.se/opencode.html/#ImDisk
[disk-start]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/start-im-disk.bat
[make-folders]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/create-folders.bat
[sys-task]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/start-ramdisk-task.xml
[in-ff]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/firefox.md
[in-gc]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/chrome.md
[in-op]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/opera.md
[in-eg]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/edge.md
[in-ie]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/BrowserCashe/iexplorer.md
[git-im-disk]: https://github.com/LTRData/ImDisk
[git-arsenal]: https://github.com/ArsenalRecon/Arsenal-Image-Mounter
