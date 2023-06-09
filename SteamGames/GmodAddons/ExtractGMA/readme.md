# Automated GMAD extractor
--------------------------------------------------------
### Description
This [`Windows`][ref-win] [batch][ref-bat] project is designed to extract your server addons autoamtically
from the [`*.gma`][ref-gma] archves of your `..common/GarrysMod/garrysmod/addons` folder.

### Installation
Installation is not needed. You have two optoions:
1. Drag a folder over the `ExportGMA.bat` and wait for the ectraction
2. Drag a file over the `ExtractSingle.bat` and wait for the ectraction

### How it works
The only file that you must edit to fit your needs is `ExportGMA.bat`. Setup it using the described features below.
The primary GMA exporter calls the processor, which handles the internal paths used in Garry's `gmad.exe` addon extractor inside the `bin` folder of Garry's mod.
    
### Features
  - You can select which addons to extract by setting the `OnlyAddons` array. Leave it empty if you want to extract all the files in the `addons` folder.
  - You san select which addons you don't want extracted via `SkipAddons`
  - You can chose the addon extension type. For gmod it's `*.gma` using `FileExt`
  - You must set where your `bin` folder of your game is located by `BinPath`
  - You must set where you want the extracted data to be stored as foolders `OutPath`
  - Beware that `SkipAddons` feature is applied on the  **specific** addons given by `OnlyAddons` and **all** of the addons in the `addons` folder, no matter which one is selected for extraction.
### External links
1) [Garry's GMAD git repo](https://github.com/garrynewman/gmad)
2) [Facepunch tread of GMAD](https://gmod.facepunch.com/f/gmoddev/lzyb/GMad-command-line-addon-creator-extractor/1/)
3) [The GMA batch in action](https://www.youtube.com/watch?v=PGxDcOWdCOE)

[![](https://img.youtube.com/vi/PGxDcOWdCOE/1.jpg)](http://www.youtube.com/watch?v=PGxDcOWdCOE "")
[![](https://img.youtube.com/vi/PGxDcOWdCOE/2.jpg)](http://www.youtube.com/watch?v=PGxDcOWdCOE "")
[![](https://img.youtube.com/vi/PGxDcOWdCOE/3.jpg)](http://www.youtube.com/watch?v=PGxDcOWdCOE "")

[ref-win]: https://www.microsoft.com/en-us/windows
[ref-bat]: https://en.wikipedia.org/wiki/Batch_file
[ref-gma]: https://fileinfo.com/extension/gma
