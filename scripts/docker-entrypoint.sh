#!/bin/bash

cat <<EOF > /usr/local/mariadb/columnstore/bin/ss-config.txt
1
mcs-1
1
1
EOF

function exitColumnStore {
  /usr/bin/monit quit
  /usr/local/mariadb/columnstore/bin/columnstore stop
}

trap exitColumnStore SIGTERM

exec "$@" &

wait
