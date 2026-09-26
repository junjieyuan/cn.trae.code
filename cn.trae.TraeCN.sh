#!/bin/bash

set -e

# Chromium/Electron needs a setuid sandbox helper, which cannot be used inside
# the Flatpak sandbox. zypak (shipped by the Electron2 BaseApp) takes care of
# that, so always launch the bundled binary through its wrapper.

# Make the host shells available so that the integrated terminal can use them.
if [ ! -e /etc/shells ] && [ -e /var/run/host/etc/shells ]; then
  ln -s /var/run/host/etc/shells /etc/shells
fi

exec env ELECTRON_RUN_AS_NODE=1 \
  /app/bin/zypak-wrapper.sh \
  /app/extra/trae-cn/trae-cn \
  /app/extra/trae-cn/resources/app/out/cli.js \
  --extensions-dir="${XDG_DATA_HOME}/trae-cn/extensions" \
  "$@"
