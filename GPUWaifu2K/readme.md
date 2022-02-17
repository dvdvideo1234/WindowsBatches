### Description
This can upscale and process images as signals using various open-source algorithms.

### Dependencies
1. [Vulcan upscaler API][ref-w2x] and [models][ref-model]
2. Standard [FFmpeg][ref-mpg] [comand line][ref-CMD] [executable][ref-exe]
3. [AMD][ref-amd] [vulcan][ref-vulc] [compatible][ref-GCN] grapics card
4. Windows 7 OS and above with `*.bat` execution enabled

### How to run
1. Convert files by calling the base convertor `convert.bat`,
   pass it the file being converted `image.jpg` and iterations `3`
 * Example: `convert.bat cute_waifu.jpg 3` will upscale only the
   desired image `cute_waifu.jpg` using `3` scaing iterations.
2. Convert folders by calling the `frames.bat` wrapper which uses
   `convert.bat` with the desired folder name. It will loop trough
   all the images and try to convert them. The result files will be
   written as the same image name in the in source folder name where
   `_out` identifier is appended.
 * Example: `frames.bat waifu_dir 2` will upscale all images in the
   `waifu_dir` folder using `convert.bat` with two iterations.

 **Node: for upscaling `*.gif` you need to expode it to frames and then
 run `frames.bat` with the folder containing the frames!**

[ref-amd]: https://www.amd.com/en
[ref-vulc]: https://www.amd.com/en/technologies/vulkan
[ref-w2x]: https://github.com/nihui/waifu2x-ncnn-vulkan
[ref-mpg]: https://ffmpeg.org/download.html
[ref-GCN]: https://www.amd.com/en/technologies/gcn
[ref-exe]: https://fileinfo.com/extension/exe
[ref-model]: https://github.com/nihui/waifu2x-ncnn-vulkan/tree/master/models
[ref-CMD]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
