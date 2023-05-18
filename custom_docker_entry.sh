#!/bin/bash

set -x
## Custom steps to configure dynamic zoo.cfg and myid files

echo "$MYID"  > "$ZOO_DATA_DIR/myid"
echo "$MYID"
if [[ -z $MYID ]]; then
       echo "1"  > "$ZOO_DATA_DIR/myid"
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"

    echo "clientPort=2181" >> "$CONFIG"
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT" >> "$CONFIG"
    echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL" >> "$CONFIG"
    echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS" >> "$CONFIG"
    echo "standaloneEnabled=$ZOO_STANDALONE_ENABLED" >> "$CONFIG"
    echo "admin.enableServer=$ZOO_ADMINSERVER_ENABLED" >> "$CONFIG"

    if [[ -z $ZOO_SERVERS ]]; then
      ZOO_SERVERS="server.1=localhost:2888:3888;2181"
    fi

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done

    if [[ -n $ZOO_4LW_COMMANDS_WHITELIST ]]; then
        echo "4lw.commands.whitelist=$ZOO_4LW_COMMANDS_WHITELIST" >> "$CONFIG"
    fi

    #custom changes
    if [[ -n $ZOO_RECONFIG ]]; then
        echo "reconfigEnabled=$ZOO_RECONFIG" >> "$CONFIG"
    fi
    if [[ -n $ZOO_SKIPACL ]]; then
        echo "skipACL=$ZOO_SKIPACL" >> "$CONFIG"
    fi
    if [[ -n $ZOO_ELECT_PORT_RETRY ]]; then
        echo "electionPortBindRetry=$ZOO_ELECT_PORT_RETRY" >> "$CONFIG"
    fi
fi



echo "-------myid---------"
cat "$ZOO_DATA_DIR/myid"
echo "-------CONF---------"
cat $CONFIG

exec "$@"