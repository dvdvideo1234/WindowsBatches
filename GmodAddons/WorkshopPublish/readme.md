### Description
[This][ref-bat-sp] [batch][ref-use-bs] is designed for a global solution regarding [Garry's mod][ref-gam-gm]
addons synchronizing with the steam workshop and GitHub. It resides here so
I will change in only one place if I need to update the publish algorithm.

### Install
This does not need to get installed. [Works, therefore it exists][ref-dec-ph].

### How to use
[Drag and drop][ref-drg-dr] a cloned GitHub addon folder onto the [`workshop_publish.bat`][ref-bat-sp] [batch][ref-use-bs] icon

### How it works
 * Configuration: The file [`.workshop`][ref-dot-ws] resides inside the addon folder and defines
    what should be extracted, combined, matched to which steam ID
  1. `WSID`: Steam workshop ID. When missing the addon is automatically
    created and the ID is assigned on creation by [steamworks][ref-api-sw].
    Write it down to this [file][ref-dot-ws] in the repository clone itself
  2. `REPO`: This key contains the actual name in the GitHub repository. Mandatory!
  2. `ADDN`: This key is used for the internal indexing of `data/.../tools`. Mandatory!
  4. `DATA`: This contains a list of directories that must be included in the new `*.gma`
 * Copy-exclusion: The file [`exclude_copy.txt`][ref-ext-cp] is used to tell `xcopy` what to skip
  when generating the `*.gma` file. When one is found in `data/.../tools/workshop` the
  batch uses it instead as it is local for the repository

### Why use it
I am an automation engineer and I prefer to automate everything to have more
personal time for myself. I am a person who values his time very much, so that
I attempt to apply this to my daily life.

[ref-bat-sp]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/GmodAddons/WorkshopPublish/workshop_publish.bat
[ref-dot-ws]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/GmodAddons/WorkshopPublish/.workshop
[ref-ext-cp]: https://github.com/dvdvideo1234/WindowsBatches/blob/master/GmodAddons/WorkshopPublish/exclude_copy.txt
[ref-gam-gm]: https://store.steampowered.com/app/4000/Garrys_Mod/
[ref-use-bs]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[ref-api-sw]: https://partner.steamgames.com/doc/api
[ref-dec-ph]: https://newlearningonline.com/new-learning/chapter-7/committed-knowledge-the-modern-past/descartes-i-think-therefore-i-am
[ref-drg-dr]: https://learn.microsoft.com/en-us/windows/apps/design/input/drag-and-drop
