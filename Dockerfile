FROM zookeeper:3.4.9

ENV ZOO_CONF_DIR=/conf \
    ZOO_DATA_DIR=/var/lib/zookeeper \
    ZOO_DATA_LOG_DIR=/datalog \
    ZOO_LOG_DIR=/logs \
    ZOO_TICK_TIME=4000 \
    ZOO_INIT_LIMIT=10 \
    ZOO_SYNC_LIMIT=3 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=3000 \
    ZOO_STANDALONE_ENABLED=true \
    ZOO_ADMINSERVER_ENABLED=true

ENV ZOO_USER=zookeeper 

RUN apk --update add curl

# Add a user with an explicit UID/GID and create necessary directories

RUN mkdir -p "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; 
RUN chown "$ZOO_USER":"$ZOO_USER" "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"

ARG DISTRO_NAME=zookeeper-3.4.9

WORKDIR /zookeeper-3.4.9
VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR", "$ZOO_LOG_DIR"]

EXPOSE 2181 2888 3888 8080

ENV PATH=$PATH:/$DISTRO_NAME/bin \
    ZOOCFGDIR=$ZOO_CONF_DIR

COPY custom_docker_entry.sh /tmp/custom_docker_entry.sh
RUN chmod 755 /tmp/custom_docker_entry.sh

ENTRYPOINT ["/tmp/custom_docker_entry.sh"]
CMD ["/zookeeper-3.4.9/bin/zkServer.sh", "start-foreground"]