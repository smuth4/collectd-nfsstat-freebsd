#!/bin/bash
HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname -f)}"
INTERVAL="${COLLECTD_INTERVAL:-10}"

# Local settings
CLIENT_STATS=true
SERVER_STATS=true
CLIENT_DATATYPE='derive'
SERVER_DATATYPE='derive'

while sleep "$INTERVAL"; do
  if [ $SERVER_STATS = true ]; then
    stats="$(nfsstat -e -s)"
    for i in {1..8}; do
      echo "$stats" | grep -v ':' | grep -v '^$' | awk "{print \$$i}" \
        | paste - - | sed '/^[[:space:]]*$/d' | sort | tr '[:upper:]' '[:lower:]' \
        | while read -r key value; do
         echo "PUTVAL $HOSTNAME/nfsstat/${SERVER_DATATYPE}-server-${key} interval=$INTERVAL N:$value"
      done
    done
  fi
  if [ $CLIENT_STATS = true ]; then
    stats="$(nfsstat -e -c)"
    for i in {1..8}; do
      echo "$stats"  | grep -v ':' | grep -v '^$' | awk "{print \$$i}" \
        | paste - - | sed '/^[[:space:]]*$/d' | sort | tr '[:upper:]' '[:lower:]' \
        | while read -r key value; do
        echo "PUTVAL $HOSTNAME/nfsstat/${CLIENT_DATATYPE}-client-${key} interval=$INTERVAL N:$value"
      done
    done
  fi
done
