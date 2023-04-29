# borgman2

## Initializing
Config:

```shell
j@troy:~/borgman2$ cat ~/.config/borgman/.borgcreds.env
export BORG_PASSPHRASE=<borg passphrase>
j@troy:~/borgman2$ cat ~/.config/borgman/.b2creds.env
RCLONE_B2_ACCOUNT=<key id>
RCLONE_B2_KEY=<key>
```

```shell
./provision.sh
```

If provisioning borg for the first time:

```shell
export BORG_REPO=/mnt/backup
sudo docker run -it --rm            \
    -v "$BORG_REPO":"$BORG_REPO"    \
    -e BORG_REPO="$BORG_REPO"       \
    jchorl/borg                     \
    init                            \
    --encryption=repokey
sudo docker run -it --rm            \
    -v "$BORG_REPO":"$BORG_REPO"    \
    -v /mnt/scrap:/mnt/scrap        \
    -e BORG_REPO="$BORG_REPO"       \
    jchorl/borg                     \
    key export                      \
    "$BORG_REPO"                    \
    /mnt/scrap/borgkey
```

## Testing
```shell
j@troy:~/borgman2$ sudo XDG_CONFIG_HOME=/home/j/.config ./run.sh
```

## Shellcheck
```shell
docker run -it --rm -v "$(pwd):/mnt" koalaman/shellcheck -x *.sh
```
