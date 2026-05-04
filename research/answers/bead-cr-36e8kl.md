# cr-36e8kl (tmux usability for Colemak/ex-terminal users)

## Answer

Recommended baseline: make `C-t` the primary prefix, keep `C-b` as a send-through binding or temporary secondary prefix during transition, enable vi-style copy mode with explicit `v`/`y` bindings, turn mouse on but keep a visible toggle, raise scrollback before creating panes, and avoid `tmux -D`/`attach -d` unless Li explicitly wants attaching in one terminal to kick other terminals off the session.

Suggested starting config:

```tmux
# Colemak-friendly prefix.
unbind C-b
set -g prefix C-t
bind C-t send-prefix
set -g prefix2 C-b
bind C-b send-prefix -2

# Lower key-sequence latency and make repeated navigation less annoying.
set -s escape-time 10
set -g repeat-time 600

# Scrollback and scroll UX. history-limit applies only to new panes.
set -g history-limit 10000
bind PageUp copy-mode -eu
bind PageDown copy-mode -ed
setw -g pane-scrollbars modal

# Copy mode.
setw -g mode-keys vi
bind Enter copy-mode
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Mouse: start enabled, but make it obvious and easy to toggle.
set -g mouse on
bind m if -F '#{mouse}' 'set -g mouse off \; display-message "mouse off"' 'set -g mouse on \; display-message "mouse on"'

# Reduce status-line noise while preserving useful tmux state.
set -g status-position top
set -g status-style bg=default,fg=colour245
set -g status-left '#S '
set -g status-right '#{?client_prefix,PREFIX ,}#{?mouse,MOUSE ,}%H:%M'
set -g renumber-windows on
set -g base-index 1
setw -g pane-base-index 1
```

For Li's launch alias, prefer this unless single-client tmux is intended:

```sh
tmux new-session -As main
```

Use this only when Li wants the new attach to detach all other attached clients:

```sh
tmux new-session -ADs main
```

## Evidence

### Prefix choice: `C-t` beats default `C-b` on vanilla Colemak

tmux defaults the primary prefix to `C-b`: the options table has `prefix` defaulting to `'b'|KEYC_CTRL`, with `prefix2` defaulting to no key (`KEYC_NONE`) (`/git/github.com/tmux/tmux/options-table.c:776-787`). tmux also supports changing the primary prefix and adding a secondary prefix: `prefix` sets the accepted prefix key, and `prefix2` sets a secondary prefix key (`/git/github.com/tmux/tmux/tmux.1:4811-4825`). The default key table also binds `C-b` to `send-prefix`, meaning pressing the prefix binding can pass the prefix key through to the pane (`/git/github.com/tmux/tmux/key-bindings.c:352-355`).

Colemak source evidence supports `C-t` as the better physical key. In xkeyboard-config's Colemak base, `t/T` is on `<AC04>` and `b/B` is on `<AB05>` (`/git/gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/symbols/us:846-862`). The row grouping in that same block places `<AC..>` keys on the home-row group and `<AB..>` keys on the bottom-row group (`/git/gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/symbols/us:846-867`). Genkey's Colemak model says the same thing more directly: `t` is on the second letter row, the home row, while `b` is on the third letter row, the bottom row, and both positions are assigned finger number `3` (`/git/github.com/semilin/genkey/layouts/colemak:1-7`). Genkey maps finger number `3` to `LI` (left index) (`/git/github.com/semilin/genkey/globals.go:20-25`), and its default dexterity table gives `LI` and `RI` the highest keys-per-second value, `5.5` (`/git/github.com/semilin/genkey/config.toml:44-54`). That means the source-backed distinction is not "T uses a better finger than B" in vanilla Colemak; it is "T uses the same high-dexterity finger from the home row, while B uses that finger from the bottom row."

If Li is using Colemak-DH rather than vanilla Colemak, `C-t` is still the home-row choice. Colemak-DH's KMonad ANSI layer places `b` on the top letter row and `t` on the home row (`/git/github.com/ColemakMods/mod-dh/kmonad/colemak-dh-extend-ansi.kbd:42-49`), and xkeyboard-config's Colemak-DH variant overrides `b/B` onto `<AD05>` while leaving the base Colemak `t/T` on `<AC04>` (`/git/gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/symbols/us:888-903` plus `/git/gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/symbols/us:846-850`).

I did not find a source-backed table that ranks "prefix key candidates by finger frequency" in the cloned sources. The evidence above supports row/finger/dexterity, not a community finger-frequency ranking.

### Community prefix patterns

The common pattern is not "everyone uses the default." tmux's own manual includes a "Changing the default prefix key" example using `C-a` (`/git/github.com/tmux/tmux/tmux.1:8307-8311`). The popular gpakosz `.tmux` config sets `prefix2 C-a` and binds `C-a send-prefix -2` (`/git/github.com/gpakosz/.tmux/.tmux.conf:22-27`); its README describes this as `C-a` acting as a secondary prefix while keeping default `C-b` (`/git/github.com/gpakosz/.tmux/README.md:208-217`). Thoughtbot's dotfiles instead set `prefix2 C-s` and bind `C-s send-prefix -2` (`/git/github.com/thoughtbot/dotfiles/tmux.conf:13-35`), and their README summarizes that as setting the prefix to `Ctrl+s` (`/git/github.com/thoughtbot/dotfiles/README.md:211-213`).

Source-backed interpretation: `C-a` and `C-s` are established community alternatives; `C-t` is not shown in the cloned community configs, but tmux's `prefix` option supports it exactly like any other key (`/git/github.com/tmux/tmux/tmux.1:4811-4825`).

### Scrollback ergonomics

tmux's `history-limit` default is 2000 lines, and the option text says a changed value applies only to new panes (`/git/github.com/tmux/tmux/options-table.c:677-686`). Community configs commonly increase it: gpakosz sets `history-limit 5000` (`/git/github.com/gpakosz/.tmux/.tmux.conf:32-32`), and thoughtbot sets `history-limit 10000` (`/git/github.com/thoughtbot/dotfiles/tmux.conf:29-30`). This is why the recommendation sets `history-limit 10000` near the top of the config.

tmux has first-class scrollback entry commands: `copy-mode -u` enters copy mode and scrolls one page up, `copy-mode -d` scrolls one page down, and `copy-mode -e` exits when scrolling returns to the visible screen (`/git/github.com/tmux/tmux/tmux.1:2496-2528`). The manual's own example binds `PageUp` and `PageDown` to `copy-mode -eu` and `copy-mode -ed` (`/git/github.com/tmux/tmux/tmux.1:2527-2532`). Newer tmux also has pane scrollbars; `pane-scrollbars modal` shows them only in copy/view mode (`/git/github.com/tmux/tmux/tmux.1:5383-5405`), and the option defaults to off (`/git/github.com/tmux/tmux/options-table.c:1390-1396`).

### Copy-mode UX

tmux defaults `mode-keys` to emacs (`/git/github.com/tmux/tmux/options-table.c:1256-1262`), but thoughtbot explicitly sets `mode-keys vi` and binds pane movement to `h/j/k/l` (`/git/github.com/thoughtbot/dotfiles/tmux.conf:4-11`). tmux's default vi copy table already has familiar vi movement and search: `h/j/k/l` move cursor, `/` searches down, `?` searches up, `g/G` jump history top/bottom, and `Space` begins selection (`/git/github.com/tmux/tmux/key-bindings.c:575-591`, `/git/github.com/tmux/tmux/key-bindings.c:591-650`). gpakosz adds the more Vim-like copy bindings `v` for begin-selection and `y` for copy-selection-and-cancel (`/git/github.com/gpakosz/.tmux/.tmux.conf:115-124`). The recommendation adopts those bindings because they reduce the "tmux copy mode is weird" tax without replacing tmux's mode system.

For clipboard integration, tmux has a server option `set-clipboard` with choices `off`, `external`, and `on` (`/git/github.com/tmux/tmux/options-table.c:84-85`, `/git/github.com/tmux/tmux/options-table.c:508-515`). gpakosz documents OS clipboard support but notes that Linux needs `xsel`, `xclip`, or `wl-copy` (`/git/github.com/gpakosz/.tmux/README.md:160-172`). Because Li's terminal/Wayland/X11 details are not in the bead, I did not hard-code a clipboard pipe in the baseline.

### Mouse mode

tmux's `mouse` option defaults off (`/git/github.com/tmux/tmux/options-table.c:767-773`), and the manual says when it is on tmux captures the mouse and allows mouse events to be bound as key bindings (`/git/github.com/tmux/tmux/tmux.1:4802-4810`). The default mouse bindings are useful once mouse mode is on: mouse drag enters copy mode, wheel-up enters copy mode unless the pane is already in alternate-screen/mouse mode, and middle-click pastes (`/git/github.com/tmux/tmux/key-bindings.c:449-458`). gpakosz's README describes mouse mode as selecting windows/panes, resizing panes, and automatically switching to copy mode for selection (`/git/github.com/gpakosz/.tmux/README.md:197-198`), and the config binds `<prefix> m` to toggle mouse mode (`/git/github.com/gpakosz/.tmux/.tmux.conf:102-107`). The local gpakosz override also suggests `set -g mouse on` and binds `m` to toggle with a visible `mouse on/off` message (`/git/github.com/gpakosz/.tmux/.tmux.conf.local:389-408`).

### Detach-on-attach behavior

`attach-session -d` is the behavior to avoid unless Li intentionally wants one visible client: tmux's manual says `attach-session -d` detaches any other clients attached to the session (`/git/github.com/tmux/tmux/tmux.1:1048-1068`). `new-session -A` behaves like `attach-session` when the named session already exists, and if `-A` is combined with `-D`, `-D` behaves like `attach-session -d` (`/git/github.com/tmux/tmux/tmux.1:1268-1334`). Therefore:

- `tmux new-session -As main` is the pleasant default for multiple terminals.
- `tmux new-session -ADs main` is the intentional "attach here, detach elsewhere" form.

This is separate from `detach-on-destroy`: that option controls what happens when the attached session is destroyed, defaulting to detaching the client (`/git/github.com/tmux/tmux/tmux.1:4650-4668`).

### Status line patterns

tmux's defaults are noisy and bright: `status-left` defaults to `[#{session_name}]`, `status-right` defaults to pane title/time/date, and `status-style` defaults to green-on-black (`/git/github.com/tmux/tmux/options-table.c:893-960`). The status line can be placed at top or bottom (`/git/github.com/tmux/tmux/options-table.c:53-55`, `/git/github.com/tmux/tmux/options-table.c:918-924`). Thoughtbot's dotfiles soften the status color and remove session/host/time "administrative debris" by emptying `status-left` and `status-right` (`/git/github.com/thoughtbot/dotfiles/tmux.conf:22-27`). gpakosz goes the other direction: it exposes rich status variables including `#{prefix}` and `#{mouse}` indicators (`/git/github.com/gpakosz/.tmux/.tmux.conf.local:260-274`). The recommendation splits the difference: neutral styling, short session name, and visible prefix/mouse state.

## Bottom line

Start with `C-t` as the real prefix for Colemak. Keep `C-b` only as migration/escape hatch through `prefix2` or remove it after muscle memory settles. Pair that with vi copy mode, `v`/`y` selection/copy, raised scrollback, mouse-on-with-toggle, `new-session -As main`, and a quiet status line that only shows state Li actually uses.
