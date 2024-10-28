FROM ubuntu:noble

# Install required packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends gcc-multilib socat adduser \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Remove any existing user with UID 1000
RUN existing_user=$(getent passwd 1000 | cut -d: -f1) \
    && if [ -n "$existing_user" ]; then deluser "$existing_user"; fi

# Set working directory
WORKDIR /home/user/cod4

# Copy required files and set ownership
COPY --chown=1000 entrypoint.sh server.cfg vendor/xbase17_00.iwd vendor/cod4x17a_dedrun ./

# Create user, set permissions, and lock down the environment
RUN adduser --system --home /home/user --uid 1000 user \
    && chown -R user: /home/user/cod4 \
    && chmod -R 700 /home/user/cod4 \
    && chmod 500 entrypoint.sh cod4x17a_dedrun

# Healthcheck to verify server status
HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD ["/bin/sh", "-c", "if [ -z \"$(echo -e '\xff\xff\xff\xffgetinfo' | socat - udp:${CHECK_IP}:${CHECK_PORT})\" ]; then exit 1; else exit 0; fi"]

# Set entrypoint to the provided script
ENTRYPOINT ["/home/user/cod4/entrypoint.sh"]

# Set default command to start the server with parameters
CMD ["+set", "dedicated", "2", "+set", "sv_cheats", "0", "+set", "sv_maxclients", "64", "+exec", "server.cfg", "+map_rotate"]

# Run the server as the created user
USER user

# Expose necessary ports for the server
EXPOSE 28960/udp
EXPOSE 28960/tcp