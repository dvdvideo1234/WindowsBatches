### Description
This batch is designed for a global solution regardin Garry's mod
addons synchronizing with the steam workshop. It resides here so
I will change in only one place if I need to udate the publish algorithm.

### Install
This does not need to get installed. Works, therefore it exists.

### How to use
Drag and drop an addon folder onto the batch icon

### How it works
 * Configuration: The file `.workshop` resides inside the addon folder and defines
    what should be extracted, combined, matched to whch steam ID
  1. `WSID`: Sheam workshop ID. When missing the addon is automatically
    created and the ID is assigned. Write it down to this file
  2. `REPO`: This key contain the actual name in the github repository. Mandatory!
  2. `ADDN`: This key is used for the internal indexinf of `data/.../tools`. Mandatory!
  4. `DATA`: This contains a list of directories that included in `*.gma`
 * Copy-exclusion: The file `exclude_copy.txt` is used to tell `xcopy` what to skip
  when geating the `*.gma` file. When one is found in `data/.../tools/workshop` the
  batch uses it instead as it is local for the repository

