set "minePath=E:\Backup\Install\EtheriumMiner\teamredminer-v0.8.5-win"
set "mineName=PhenomII"
set "mineWall=0x5f85dc88f23636B100d8C015171021cDDA7C369d"
set "mineBase=stratum+ssl://eth-de.flexpool.io:5555"
set "mineBack=stratum+ssl://eth-se.flexpool.io:5555"
set "mineAlloc=4078"

call %minePath%\teamredminer.exe -a ethash -o %mineBase% -u %mineWall%.%mineName% -o %mineBack% -u %mineWall%.%mineName% -p x --eth_4g_max_alloc=%mineAlloc% --eth_stratum ethproxy
