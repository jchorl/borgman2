#!/bin/sh

set -eux

export BORGMAN_CONFIG_DIR="$XDG_CONFIG_HOME/borgman"
export DATA_DIR=/mnt/data
export BORG_REPO=/mnt/backup
export B2_BUCKET=borgman-backup-from-21-03-2021
