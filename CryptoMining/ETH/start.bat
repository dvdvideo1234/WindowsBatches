set "minePath=E:\Backup\Install\EtheriumMiner\teamredminer-v0.8.5-win"

call %minePath%\teamredminer.exe -a ethash -o stratum+ssl://eth-de.flexpool.io:5555 -u 0x5f85dc88f23636B100d8C015171021cDDA7C369d.PhenomII -o stratum+ssl://eth-se.flexpool.io:5555 -u 0x5f85dc88f23636B100d8C015171021cDDA7C369d.PhenomII -p x --eth_stratum ethproxy
