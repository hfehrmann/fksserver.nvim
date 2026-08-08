#!/usr/bin/env bash
$(command -v lemmy-help &> /dev/null)
VC_EXISTS=$?

VC_MAJOR=0
VC_MINOR=11

VC_REQUIRED_VERSION="Install lemmy-help +$VC_MAJOR.$VC_MINOR.0"
if [ $VC_EXISTS -eq 1 ]; then
    echo $VC_REQUIRED_VERSION >&2
    exit 1
fi

VC_VERSION=$(lemmy-help -v | sed 's|lemmy-help \(.*\)|\1|')
IFS=. read -r major minor fix < <(echo "$VC_VERSION")

if [ $major -ne $VC_MAJOR ] || [ $minor -lt $VC_MINOR ]; then
    echo "Your version is $major.$minor.$fix" >&2
    echo $VC_REQUIRED_VERSION >&2
    exit 1
fi

CURRENT="$(basename $(pwd))"

if [ "$CURRENT" != "fksserver.nvim" ]; then
    echo "Run the doc generation from the root!" >&2
    exit 1
fi

lemmy-help --layout compact:0 \
  --indent 2 \
  -f -t -a -c \
  lua/fksserver/{init,focus,commands,fksnv}.lua \
  lua/fksserver/terminal/init.lua \
  lua/fksserver/terminal/hosting.lua \
  lua/fksserver/terminal/iTerm.lua \
  lua/fksserver/terminal/macTerminal.lua \
  lua/fksserver/terminal/tmux.lua \
  > doc/fksserver.txt
