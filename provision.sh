#!/bin/sh

set -eux

. ./helpers.sh
. ./variables.sh

check_env_var "$XDG_CONFIG_HOME"
mkdir -p "$BORGMAN_CONFIG_DIR"
check_dir_exists "$BORGMAN_CONFIG_DIR"
check_file_exists "$BORGMAN_CONFIG_DIR/.borgcreds.env"
check_file_exists "$BORGMAN_CONFIG_DIR/.b2creds.env"

mkdir -p "$XDG_CONFIG_HOME/rclone"

sudo docker run -it --rm \
    -v "$XDG_CONFIG_HOME/rclone":/config/rclone \
    --env-file "$BORGMAN_CONFIG_DIR/.b2creds.env" \
    rclone/rclone:latest \
    config

sudo docker run -it --rm \
    -v "$XDG_CONFIG_HOME/rclone":/config/rclone \
    --env-file "$BORGMAN_CONFIG_DIR/.b2creds.env" \
    rclone/rclone:latest \
    mkdir \
    remote:"$B2_BUCKET"

# cron files must be owned by root
sudo chown root:root *.sh

# sudo ln -sf "$(pwd)/run.sh" /etc/cron.weekly/borgman
# or, running at a specific time:
echo "run sudo crontab -e"
echo "it should look like:"
echo << EOF
j@troy:~/borgman2$ sudo crontab -l
# m h  dom mon dow   command
0 9 * * 3 XDG_CONFIG_HOME=/home/j/.config /home/j/borgman2/run.sh 2>&1 >> /home/j/borglogs
EOF
