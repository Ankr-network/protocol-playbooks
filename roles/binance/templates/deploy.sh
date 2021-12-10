#!/bin/bash
set -x
snapshot={{snapshot}}
FILE_INIT={{dir}}/init_succeeded.txt
if [ -f "$FILE_INIT" ]; then
    echo "Already initialized"
else
  geth --datadir {{dir}} init "{{dir}}/config/{{network}}/genesis.json"
  echo OK > {{dir}}/init_succeeded.txt
fi

if [ "True" = "$snapshot" ]; then
    FILE_SNAPSHOT={{dir}}/snapshot_succeeded.txt
    if [ -f "$FILE_SNAPSHOT" ]; then
        echo "Snapshot is downloaded"
    else
      wget --continue -O {{dir}}/geth.tar.gz "{{ snap_link }}" 2>&1 | tee -a {{dir}}/wget_log
      cd {{dir}}
      tar zxvf geth.tar.gz
      # rm geth.tar.gz
      rm -rf {{dir}}/geth/*
      geth --datadir {{dir}} init "{{dir}}/config/{{network}}/genesis.json"
      mv {{dir}}/server/data-seed/geth/* {{dir}}/geth/
      echo OK > {{dir}}/snapshot_succeeded.txt
      rm -rf {{dir}}/server
    fi
fi

geth --config "{{dir}}/config/{{network}}/config.toml" --syncmode {{sync_mode}} --gcmode {{gc_mode}} --datadir {{dir}} --txpool.globalslots 50000 --txpool.accountslots 5 --snapshot  --diffsync --cache 60000  --txlookuplimit 0
