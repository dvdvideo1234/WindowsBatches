### Description
This project is used to integrate a desired driver pack inside a USB flash drive windows installation.

### What you will need
 1. A place where tou can get a [genuine Windows OS copy](https://www.microsoft.com/en-us/software-download/windows10).
 2. A [flash drive](https://www.google.com/search?q=8GB+flash+drive&client=firefox-b-d&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjVuLbgodLhAhUR0aYKHaryAwAQ_AUIDigB&biw=1536&bih=711) with more than 8 GB of memory available
 3. A USB flash drive MBR/GPT modificator OS image transfering [tool like Rufus](https://rufus.ie/)
 4. A proper version of [DISM](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism---deployment-image-servicing-and-management-technical-reference-for-windows) integrated with Win7 and above
 
### How to install
Just copy both files in a folder of choise on your hard drive

### How to use this project to create a driver integrated USB flash drive
To integrate the desirted driver pack on the USB drive, you need both `*.bat`
files so copy them to the folder of choise. I am gonna call it `$INSTALL`.
Go to your `$INSTALL` folder and create a folder called `Drivers`.
Fill the `Drivers` folder with the driver pack you want to integrate
and when you are ready connect your flash drive to the PC's USB port.
Once connected, Windows will assign a drive letter to your flash drive.
When I connected mine it assigned drive `H:\`, but yours may differ.
I'm gonna call this USB flash drive letter `$LETTER` for the sake of the tutorial.
Now go to `$LETTER\sources` and copy both files `install.wim` and `boot.wim` to the
`$INSTALL` directory you've created earlier so we can start the integration process.
The `*.wim` files are separeted internally by integer indexes. That means you can
have multiple images assigned to one `*.wim` file where each one has its own index inside.
You have to modify both files for this to work, then let's start with `boot.wim`:

Type `print boot` and hit `ENTER` and you will have output like this:

```
Index 1
Details for image : boot.wim
```

Type `print install` and hit `ENTER` and you will have output like this:

```
Index 1
Details for image : install.wim
```

As you see above, you've obtained the internal indexes of the image you want to modify
to start the integration process just type the following `apply boot 1` where `1` is
your internal index. Wait for it to finish and unmount itself from the mount folder
and repeat the same procedure `apply intall 1`. Wait for it to get done and unmount
the image, then copy `boot.wim` and `install.wim` to `$LETTER\sources`.

### Additoional information
The entire process is [described here](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/mount-and-modify-a-windows-image-using-dism) and this project just automates it.
