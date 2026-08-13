# PicoShare Role

Installs [PicoShare](https://github.com/mtlynch/picoshare) as a systemd user service for the `picoshare` user.

## Managing the service as root

PicoShare runs as a *user* service inside the `picoshare` user's systemd instance, so as root you cannot use plain `systemctl`/`journalctl` on it. Run the commands as the `picoshare` user with `XDG_RUNTIME_DIR` set:

```sh
# Status
sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) systemctl --user status picoshare

# Start / stop / restart
sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) systemctl --user start picoshare
sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) systemctl --user stop picoshare
sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) systemctl --user restart picoshare

# Tail the logs
sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) journalctl --user -u picoshare -f
```

To save typing, define this helper once per shell session:

```sh
psu() { sudo -u picoshare XDG_RUNTIME_DIR=/run/user/$(id -u picoshare) "$@"; }
psu systemctl --user status picoshare
psu journalctl --user -u picoshare -f
```

As root, the shortest way to follow the logs is to filter the system journal for the user unit:

```sh
journalctl _SYSTEMD_USER_UNIT=picoshare.service -f
```

Note that `journalctl --user-unit=picoshare` does **not** work for this, not even as root: `--user-unit` scopes to the invoking user's *own* user manager, and root's manager has no `picoshare.service`. Only the `picoshare` user itself (via `psu`) can use `--user`/`--user-unit`.

The service starts automatically at boot; lingering is enabled for the `picoshare` user by the role.
