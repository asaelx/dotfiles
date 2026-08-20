# dotfiles

Personal Linux desktop configuration. Built around **bspwm** as a tiling window manager with a consistent [Embark](https://embark-theme.github.io/) color scheme across all components.

## Stack

| Component | Software |
|-----------|----------|
| WM | bspwm |
| Hotkeys | sxhkd |
| Bar | polybar |
| Terminal | alacritty |
| Launcher | rofi |
| Compositor | picom |
| Shell | zsh (oh-my-zsh, `ys` theme) |
| Editor | vim (vim-plug) |
| File manager | ranger |
| Notifications | dunst |
| Font | JetBrains Mono |

## Layout

Two-monitor setup: `DisplayPort-2` hosts desktops 1–4, `HDMI-A-0` hosts desktops 5–8.

## Keybindings (sxhkd)

`alt` is the primary modifier. Key highlights:

| Key | Action |
|-----|--------|
| `alt + Return` | Open terminal (alacritty) |
| `alt + d` | App launcher (rofi) |
| `alt + {h,j,k,l}` | Focus window (vim directions) |
| `alt + shift + {h,j,k,l}` | Move window |
| `alt + {1–9}` | Focus desktop |
| `alt + shift + {1–9}` | Send window to desktop |
| `alt + {t,s,f}` | Tiled / floating / fullscreen |
| `alt + m` | Toggle monocle layout |
| `alt + shift + u` | Lock screen (betterlockscreen) |
| `alt + x` | Screenshot (flameshot) |
| `super + alt + {q,r}` | Quit / restart bspwm |

## Deployment

No install script — symlink files manually from `$HOME` to the repo. The `.scripts/` directory should be deployed as `~/.scripts/`, with `~/.scripts/bin/` on `$PATH` (already set in `.zshrc`).

```sh
ln -sf ~/Code/dotfiles/.zshrc ~/.zshrc
ln -sf ~/Code/dotfiles/.aliases ~/.aliases
ln -sf ~/Code/dotfiles/.vimrc ~/.vimrc
ln -sf ~/Code/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/Code/dotfiles/.scripts ~/.scripts
ln -sf ~/Code/dotfiles/.config/bspwm ~/.config/bspwm
# ... etc.
```

## Scripts (`.scripts/`)

| Script / command | Purpose |
|-----------------|---------|
| `ran` | Generate a random filename string — used as a building block by other scripts |
| `vimv` | Batch-rename files by editing a list in vim |
| `ins` / `sins` | Instagram image handling and HDD sync |
| `usernames.sh` | Crop username region from PNG screenshots (ImageMagick) |
| `2mp4.sh`, `concat_videos.sh`, `video_to_gif.sh` | ffmpeg video utilities |
| `wallhaven.sh` | Download wallpapers from Wallhaven |
| `news/` | Polybar news ticker module (Python + shell) |

## tmux

Prefix is `C-a`. Pane navigation with `Alt+Arrow`. Copy mode uses vi keys; `y` yanks to clipboard via `xclip`.
