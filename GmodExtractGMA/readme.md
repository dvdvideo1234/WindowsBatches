# Automated GMAD extractor
--------------------------------------------------------
### Description
This `Windows` batch project is designed to extract your server addons autoamtically from the `*.gma` archves of your `..common/GarrysMod/garrysmod/addons` folder.

### Installation
Clone this repository to a folder of preference, then grab the files `ExportGMA.bat` and `Processor.bat` and place them into the `addons` folder of the game.

### How it works
The only file that you must edit to fit your needs is `ExportGMA.bat`. Setup it using the described features below. The file `Processor.bat` is a core functionality. Do _**not**_ touch it. The primary GMA exporter calls the processor, which handles the internal paths used in Garry's `gmad.exe` addon extractor inside the `bin` folder of Garry's mod.
    
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
3) [The GMA batch in action](https://youtu.be/PGxDcOWdCOE)