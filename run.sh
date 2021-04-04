#!/bin/sh

set -eux

. "$(dirname $0)/helpers.sh"
. "$(dirname $0)/variables.sh"

check_dir_exists "$BORGMAN_CONFIG_DIR"

# shellcheck disable=SC1091
. "$BORGMAN_CONFIG_DIR/.borgcreds.env"

check_env_var "$XDG_CONFIG_HOME"
check_dir_exists "$DATA_DIR"
check_non_empty "$DATA_DIR"
check_dir_exists "$BORG_REPO"
check_env_var BORG_PASSPHRASE

sudo docker run --rm                      \
    -v "$DATA_DIR":"$DATA_DIR"            \
    -v "$BORG_REPO":"$BORG_REPO"          \
    -e BORG_REPO="$BORG_REPO"             \
    -e BORG_PASSPHRASE="$BORG_PASSPHRASE" \
    jchorl/borg                           \
    create                                \
    --stats                               \
    --show-rc                             \
    --compression lz4                     \
    --exclude-caches                      \
    ::'data-{now}'                        \
    "$DATA_DIR"

check_non_empty "$BORG_REPO"

sudo docker run --rm                      \
    -v "$DATA_DIR":"$DATA_DIR"            \
    -v "$BORG_REPO":"$BORG_REPO"          \
    -e BORG_REPO="$BORG_REPO"             \
    -e BORG_PASSPHRASE="$BORG_PASSPHRASE" \
    jchorl/borg                           \
    prune                                 \
    --prefix 'data-'                      \
    --show-rc                             \
    --keep-daily    1                     \
    --keep-weekly   2                     \
    --keep-monthly  6

sudo docker run --rm \
    -v "$BORG_REPO":/data \
    -v "$XDG_CONFIG_HOME/rclone":/config/rclone \
    --env-file "$BORGMAN_CONFIG_DIR/.b2creds.env" \
    rclone/rclone:latest \
    sync \
    /data \
    remote:"$B2_BUCKET" \
    --fast-list \
    --transfers 32 \
    --b2-hard-delete

sudo docker run --rm \
    jchorl/wdping \
    --name borgman \
    --frequency weekly \
    --domain https://watchdog.joshchorlton.com
