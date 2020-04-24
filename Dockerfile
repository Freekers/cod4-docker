FROM ubuntu:focal
EXPOSE 28960/udp
EXPOSE 28960/tcp
WORKDIR /home/user/cod4
COPY --chown=1000 entrypoint.sh server.cfg vendor/xbase17_00.iwd vendor/cod4x17a_dedrun ./
RUN adduser --system user --home /home/user --uid 1000 && \
    chown -R user /home/user && \
    chmod -R 700 /home/user && \
    chown -R user /home/user/cod4 && \
    chmod -R 700 /home/user/cod4 && \
    chmod 500 entrypoint.sh cod4x17a_dedrun
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends gcc-multilib && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "/home/user/cod4/entrypoint.sh" ]
CMD +set dedicated 2+set sv_cheats 0+set sv_maxclients "64"+exec server.cfg+map_rotate
USER user
