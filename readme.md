# COD4x 1.7a Dedicated Server in Docker

*Call of Duty 4 Dedicated Server based on COD4x 1.7a as Docker image*

[![Docker Cod4](https://github.com/freekers/cod4-docker/raw/master/images/title.png)](https://github.com/Freekers/cod4-docker/)

It is based on:

- [Ubuntu](https://ubuntu.com)
- [Cod4x](https://github.com/callofduty4x/CoD4x_Server)

## Requirements

- COD4 Client game version 1.7
- Original COD4 **main** and **zone** files required (from the client installation directory)

## Features

- [Cod4x server features](https://github.com/callofduty4x/CoD4x_Server#the-most-prominent-features-are)
- Works with custom mods and maps (see the [Mods section](#Mods))
- Easily configurable with [docker-compose](#using-docker-compose)
- Runs without root (safer)
- Default cod4 configuration file [server.cfg](https://github.com/freekers/cod4-docker/blob/master/server.cfg)
    - Placed into `./main`
    - Launched by default when not using mods with `exec server.cfg`
    - Easily changeable

## Setup

We assume your *call of duty 4 game* is installed at `/mycod4path`

1. On your host, create the directories `./main`, `./zone`, `./mods` and `./usermaps`.
1. From your Call of Duty 4 installation directory:
    - Copy all the `.iwd` files from `/mycod4path/main` to `./main`
    - Copy all the files from `/mycod4path/zone` to `./zone`
    - (Optional) Copy the mods you want to use from `/mycod4path/mods` to `./mods`
    - (Optional) Copy the maps you want to use from `/mycod4path/usermaps` to `./usermaps`
1. As the container runs as user ID 1000 by default, fix the ownership and permissions:

    ```bash
    chown -R 1000 main mods usermaps zone
    chmod -R 700 main mods zone usermaps
    ```

    You can also run the container with `--user="root"` (unadvised!)

1. Run the following command as root user on your host:

    ```bash
    docker run -d --name=cod4 -p 28960:28960/udp \
        -v $(pwd)/main:/home/user/cod4/main \
        -v $(pwd)/zone:/home/user/cod4/zone:ro \
        -v $(pwd)/mods:/home/user/cod4/mods \
        -v $(pwd)/usermaps:/home/user/cod4/usermaps:ro \
        qmcgaw/cod4 +map mp_shipment
    ```

    The command line argument `+map mp_shipment` is optional and defaults to `+set dedicated 2+set sv_cheats "1"+set sv_maxclients "64"+exec server.cfg+map_rotate`

    You can also download and modify the [*docker-compose.yml*](https://raw.githubusercontent.com/freekers/cod4-docker/master/docker-compose.yml) file and run

    ```bash
    docker-compose up -d
    ```

## Testing

1. Launch the COD4 multiplayer game
1. Click on **Join Game**
1. Click on **Source** at the top until it's set on *Favourites*
1. Click on **New Favourite** on the top right
1. Enter your host LAN IP Address (i.e. `192.168.1.26`)
    - Add the port if you run it on something else than port UDP 28960 (i.e. `192.168.1.26:28961`)
1. Click on **Refresh** and try to connect to the server in the list

![COD4 screenshot](https://github.com/Freekers/cod4-docker/blob/master/images/test.png?raw=true)

## Mods

Assuming:

- Your mod directory is `./mymod`
- Your main mod configuration file is `./mymod/server.cfg`

Set the command line option to `+set dedicated 2+set sv_cheats "1"+set sv_maxclients "64"+set fs_game mods/mymod+exec server.cfg +map_rotate`

## Write protected args

The following parameters are write protected and **can't be placed in the server configuration file**, 
and must be in the `ARGS` environment variable:

- `+set dedicated 2` - 2: open to internet, 1: LAN, 0: localhost
- `+set sv_cheats "1"` - 1 to allow cheats, 0 otherwise
- `+set sv_maxclients "64"` - number of maximum clients
- `+exec server.cfg` if using a configuration file
- `+set fs_game mods/mymod` if using a custom mod
- `+set com_hunkMegs "512"` don't use if not needed
- `+set net_ip 127.0.0.1` don't use if not needed, requires `host` network mode
- `+set net_port 28961` don't use if not needed, requires `host` network mode
- `+map_rotate` OR i.e. `+map mp_shipment` **should be the last launch argument**

## Masterlist

In order for the server to show up on the Activision Masterlist, you need to use `host` network mode for the container so that it can bind to the WAN/Internet IP address of your server. Additionally, you need to set `+set net_ip 123.123.123.123 +set net_port 28961` as `ARGS` environment variable.

If using `bridge` network mode, the container will bind to the IP address of the Docker network and therefore won't show up on the Activision Masterlist, as the heartbeat will send a ['local' IP-address](https://docs.docker.com/network/network-tutorial-standalone/) to the Masterserver (e.g. 172.16.X.X.).

**Note**: This version of COD4x (1.7a) is no longer compatible with the [COD4**x** Masterserver](http://cod4master.cod4x.me/) as [it now requires a token to be listed](https://cod4x.me/index.php?/forums/topic/2814-new-requirement-for-cod4-x-servers-to-get-listed-on-masterserver/), which has not been implemented/backported to COD4x version 1.7a.

## Acknowledgements

- Credits to the developers of Cod4x server
- Forked from [qdm12/cod4-docker](https://github.com/qdm12/cod4-docker)
