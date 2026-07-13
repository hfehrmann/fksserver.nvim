# Fokus Server (fksserver)

Make your NeoVim instance focusable

Useful when you need a "main" NeoVim instance and you want to link files back to
it. This can enable "Open in NeoVim" from other places.

This is the nvim counterpart for `code`, `subl` and `xed`

Currently, this plugin works in the following environments:

- MacOs
  - iTerm
    - tmux
  - Terminal
    - tmux

## Configuration

You need to setup the host environment in order for this plugin to work.

### iTerm

This case should work out of the box.

### iTerm + tmux

You have to add the following to your `.tmux.conf` to correctly identify the
running iTerm session from tmux

```
set-option -ga update-environment "ITERM_SESSION_ID"
```

### Terminal

Add the following to your .rc file

```
export FKSSERVER_TTY=`tty`
```

### Terminal + tmux

In addition to the base Terminal configuration, you have to add the following
to your `.tmux.conf` to correctly identify the running Terminal session.

```
set-option -ga update-environment "TERM_SESSION_ID"
set-option -ga update-environment "FKSSERVER_TTY"
```

## fksnv script

The `fksnv` tool can open files in the running NeoVim focus server, and focus
into it. You can install the script from within NeoVim with `:FKSInstall`.

