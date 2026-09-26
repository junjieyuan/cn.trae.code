# Trae CN Flatpak

🚨 Warning: This is an unofficial Flatpak build of Trae CN, generated from the
official vendor-built `.deb` packages published on `lf-cdn.trae.com.cn`. This
repackaging is not supported by the vendor.

## Usage

Build and install the app:

```sh
flatpak-builder --user --force-clean --repo=repo --install \
  --install-deps-from=flathub build cn.trae.TraeCN.yaml
flatpak run cn.trae.TraeCN
```

User data and extensions are kept inside the sandbox instead of the host's
`~/.trae-cn`:

- user data: `~/.var/app/cn.trae.TraeCN/config/Trae CN`
- extensions: `~/.var/app/cn.trae.TraeCN/data/trae-cn/extensions`

Flatpak runs in an isolated environment, so some work is necessary to reach the
host system.

### Execute commands in the host system.

To execute commands on the host system, run inside the sandbox:

`$ flatpak-spawn --host <COMMAND>`

or

`$ host-spawn <COMMAND>`

- Most users seem to report a better experience with `host-spawn`.

### Use host shell in the integrated terminal.

Another option to execute commands is to use your host shell in the integrated
terminal instead of the sandbox one.

For that go to `File -> Preferences -> Settings` and find
`Features > Terminal > Integrated > Profiles`, then click on
`Edit in settings.json` (The important thing here is to open settings.json)

`flatpak-spawn --host`

```json
{
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.profiles.linux": {
    "bash": {
      "path": "/usr/bin/flatpak-spawn",
      "args": ["--host", "--env=TERM=xterm-256color", "bash"],
      "icon": "terminal-bash",
      "overrideName": true
    }
  }
}
```

`host-spawn`

```json
{
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.profiles.linux": {
    "bash": {
      "path": "/app/bin/host-spawn",
      "args": ["bash"],
      "icon": "terminal-bash",
      "overrideName": true
    }
  }
}
```

- You can change **bash** to any terminal you are using: zsh, fish, sh.
- `overrideName` allows for the 'name' (or whatever you set it to) of the shell
  you're using to appear (e.g. normally zsh, fish, sh).

## Updating

Both `extra-data` sources carry `x-checker-data` pointing at the vendor's
release API, so the pinned version can be bumped with:

```sh
flatpak-external-data-checker --update cn.trae.TraeCN.yaml
```

The `<release>` entry in `cn.trae.TraeCN.metainfo.xml` has to be updated by
hand afterwards.

## Known issue when building on Fedora 44

Flatpak 1.18.2 has an upstream regression that breaks `flatpak build-init` on
SELinux systems (`lsetxattr(security.selinux): Operation not supported`), see
[flatpak#6818](https://github.com/flatpak/flatpak/issues/6818). Build with
Flatpak >= 1.18.3, or put a working `flatpak` CLI earlier in `PATH`.

If `fusermount3` complains with `failed to access mountpoint ...: Permission
denied`, a previous build left a dangling mount behind (note that
`fusermount3` takes one mountpoint per run, no globs):

```sh
for p in .flatpak-builder/rofiles/rofiles-*; do [ -d "$p" ] && fusermount3 -uz "$p"; done
rm -rf .flatpak-builder/rofiles
```

Then retry the build, adding `--disable-rofiles-fuse` if it happens again.

## Support

Unofficial repackaging: please report problems with this Flatpak here, and
problems with the application itself to the vendor.

## Credits

This packaging is derived from the [Flathub Visual Studio Code
manifest](https://github.com/flathub/com.visualstudio.code) (`com.visualstudio.code`),
which is where the structure of this repository comes from: the
`extra-data` + `apply_extra` handling, the
[zypak](https://github.com/refi64/zypak)-based launcher and the `host-spawn`
integration all follow that manifest.
