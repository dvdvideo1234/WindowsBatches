### Description
This project is used to integrate the desired driver pack inside a USB flash drive windows installation.

### What you will need
 1. A place where you can get a [genuine Windows OS copy](https://www.microsoft.com/en-us/software-download/windows10).
 2. A [flash drive](https://www.google.com/search?q=8GB+flash+drive) with more than 8 GB of memory available
 3. A USB flash drive MBR/GPT OS image transferring [tool like Rufus](https://rufus.ie/)
 4. A proper version of [DISM](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism---deployment-image-servicing-and-management-technical-reference-for-windows) integrated with Win7 and above
 
### How to install
Just copy both files in a folder of choice on your hard drive

### How to use this project to create a driver integrated USB flash drive
To integrate the desired driver pack on the USB drive, you need both `*.bat`
files, so copy them to the folder of choice. I am gonna call it `$INSTALL`.
Go to your `$INSTALL` folder and create a folder called `Drivers`.
Fill the `Drivers` folder with the driver pack you want to integrate
and when you are ready to connect your flash drive to the PC's USB port.
Once connected, Windows will assign a drive letter to your flash drive.
When I connected mine, it assigned drive `H:\`, but yours may differ.
I'm gonna call this USB flash drive letter `$LETTER` for the sake of the tutorial.
Now go to `$LETTER\sources` and copy both files `install.wim` and `boot.wim` to the
`$INSTALL` directory you've created earlier so we can start the integration process.
The `*.wim` files are separated internally by integer indexes. This means you can
have multiple images assigned to one `*.wim` file where each one has its own index inside.
You have to modify both files for this to work, then let's start with `boot.wim`:

Type `print boot` and hit `ENTER` and you will have an output like this:

```
Index 1
Details for image : boot.wim
```

Type `print install` and hit `ENTER` and you will have an output like this:

```
Index 1
Details for image : install.wim
```

As you see above, you've obtained the internal indexes of the image you want to modify
to start the integration process just type the following `apply boot 1` where `1` is
your internal index. Wait for it to finish and unmount itself from the mount folder
and repeat the same procedure `apply install 1`. Wait for it to get done and unmount
the image, then copy `boot.wim` and `install.wim` to `$LETTER\sources`.

### Additional information
The entire process is [described here](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/mount-and-modify-a-windows-image-using-dism) and this project just automates it.
