ARG DEBIAN_VERSION=stretch-slim
ARG ALPINE_VERSION=3.10

FROM alpine:${ALPINE_VERSION}
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.schema-version="1.0.0-rc1" \
    maintainer="quentin.mcgaw@gmail.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/qdm12/cod4-docker" \
    org.label-schema.url="https://github.com/qdm12/cod4-docker" \
    org.label-schema.vcs-description="Call of duty 4X Modern Warfare dedicated server" \
    org.label-schema.vcs-usage="https://github.com/qdm12/cod4-docker/blob/master/README.md#setup" \
    org.label-schema.docker.cmd="see readme of Github page" \
    org.label-schema.docker.cmd.devel="see readme of Github page" \
    org.label-schema.docker.params="" \
    org.label-schema.version="1.8-17.7.2" \
    image-size="20.9MB" \
    ram-usage="80MB to 150MB" \
    cpu-usage="Low"
EXPOSE 28960/udp
WORKDIR /home/user/cod4
COPY --chown=1000 entrypoint.sh server.cfg vendor/xbase17_00.iwd vendor/cod4x17a_dedrun ./
RUN adduser -S user -h /home/user -u 1000 && \
    chown -R user /home/user && \
    chmod -R 700 /home/user && \
    chown -R user /home/user/cod4 && \
    chmod -R 700 /home/user/cod4 && \
    chmod 500 entrypoint.sh cod4x17a_dedrun && \
    chmod +x entrypoint.sh cod4x17a_dedrun
ENTRYPOINT [ "/home/user/cod4/entrypoint.sh" ]
CMD +set dedicated 2+set sv_cheats "1"+set sv_maxclients "64"+exec server.cfg+map_rotate
USER user
