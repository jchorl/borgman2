#!/bin/sh

check_file_exists () {
    if [ ! -f "$1" ]; then
        echo "file $1 does not exist"
        exit 1
    fi
}

check_dir_exists () {
    if [ ! -d "$1" ]; then
        echo "dir $1 does not exist"
        exit 1
    fi
}

check_non_empty () {
    if [ -z "$(ls -A "$1")" ]; then
        echo "dir /mnt/data is empty"
        exit 1
    fi
}

check_env_var () {
    if [ -z "$1" ]; then
        echo "env var $1 is undefined/empty"
        exit 1
    fi
}
