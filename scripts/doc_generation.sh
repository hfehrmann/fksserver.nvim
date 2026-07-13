CURRENT="$(basename $(pwd))"

if [ "$CURRENT" != "fksserver.nvim" ]; then
    echo "Run the doc generation from the root!" >&2
    exit 1
fi

vimcats --layout compact:0 \
  --indent 2 \
  -f -t -a -c \
  lua/fksserver/{init,focus,commands,fksnv}.lua \
  lua/fksserver/terminal/init.lua \
  lua/fksserver/terminal/hosting.lua \
  lua/fksserver/terminal/iTerm.lua \
  lua/fksserver/terminal/macTerminal.lua \
  lua/fksserver/terminal/tmux.lua \
  > doc/fksserver.txt
