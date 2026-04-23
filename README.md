# Chrony
Chrony server based on Alpine Linux.

## Quick reference
* Where to file issues:
[GitHub](https://github.com/gianlucavagnuzzi/chrony/issues)

* Supported architectures: amd64 , armv7 , arm64v8

## How to run
### With docker run
```
docker run -di --network host -e ALLOW_CIDR=0.0.0.0/0 rardcode/chrony
```

### With docker-compose file
```
services:
  app:
    image: rardcode/chrony
    container_name: chrony
    environment:
      - ALLOW_CIDR=0.0.0.0/0 # clients to connect and get the time. Default is none.
      #- NTP_SERVER=time.inrim.it # The NTP server to get the time to set from. Default is pool.ntp.org.
      #- SYNC_RTC=false # Sync the realtime clock on the machine/instance the service is running. Default is true.
    network_mode: host # Recommended so that clients come with the real ip, otherwise they would all get with only ip, that of the docker
    cap_add:
      - SYS_TIME
    restart: unless-stopped

```

Useful commands:
```
docker exec chrony /bin/sh -c "chronyc clients"
docker exec chrony /bin/sh -c "chronyc sources"
```

## Changelog
### v3234.48r2 - 23.04.2026
- Alpine v.3.23.4

### v3233.48r2 - 20.03.2026
- Alpine v.3.23.3
- Chrony v.4.8-r2
