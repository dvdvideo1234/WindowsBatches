:: Create 16GB drive, mount it to K: and format with NTFS
call imdisk -a -s 16G -m "%1" -p "/fs:ntfs /q /y"

call create-folders.bat "%1"
