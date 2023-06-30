The tar.gz files here are OpenWRT configuration backup files.
This configuration supports a mwan3 failover mode with `wan`
being the primary interface and `wanb` the secondary/failover
interface. Of important note is that I've modifed the backup
configuration using [System -> Backup/Flash Firmware] and then
clicking the [Configuration] tab. There I added "/root/". The
result is that etc/systemupgrade.conf contains:
```
$ cat etc/sysupgrade.conf
7:/root/
```

See https://openwrt.org/docs/guide-user/network/wan/multiwan/mwan3
for mwan3 configuration and in the archive see root/README for
more other configuration information.
