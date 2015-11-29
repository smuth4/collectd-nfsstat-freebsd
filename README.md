# collectd-nfsstat-freebsd
A small script to gather counters from the nffstat command (FreeBSD version) to send to collectd.

This uses the `-e` flag to gather stats, and has not been tested against NFS v3.

## Installation

```bash
https://github.com/smuth4/collectd-nfsstat-freebsd
cd collectd-nfsstat-freebsd
sudo mkdir /usr/local/etc/collectd.d/
sudo cp nfsstash.sh /usr/local/etc/collectd.d/ && sudo chmod +x /usr/local/etc/collectd.d/nfsstash.sh
```

## Configuration
Edit the script and adjust the default `$INTERVAL`, or change `CLIENT_STATS` or `SERVER_STATS` to ``alse` to gather only client or only server stats respectively.

By default, I use to Graphite's rewrite

Configure collectd to use the new script. Somewhere in the configuration file, add the following:
```
LoadPlugin exec
<Plugin exec>
	Exec nobody "/usr/local/etc/collectd.d/nfsstat.sh"
</Plugin>
```

## Notes

Regarding the datatype, having ``derive`` as the datatype is ugly, but I use Graphite rules to strip it out. To change it natively in collectd, edit your types.db to have a custom entry, and change the `CLIENT_DATATYPE` and `SERVER_DATATYPE` to use that entry.
