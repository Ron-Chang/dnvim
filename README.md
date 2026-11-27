# dnvim

Portable Neovim in a container: plugins, LSP servers and treesitter parsers preinstalled.
Only needs Docker on the host.

## Usage

```bash
bash <(curl -fsSL https://nvim.ronchang.io)            # current directory, dashboard
bash <(curl -fsSL https://nvim.ronchang.io) WORKPATH   # directory: dashboard there; file: open it
curl -fsSL https://nvim.ronchang.io | bash -s -- WORKPATH
```

Inspect before running: `curl -fsSL https://nvim.ronchang.io | less`

## Environment

| Variable | Default | Description |
|---|---|---|
| `NVIM_IMAGE` | `ronhsienchang/dnvim:latest` | Image to run |
| `NVIM_THEME` | `tokyonight` | `gruvbox`, `gruvbox-material`, `monokai`, `monokai-pro`, `nord`, `onedark`, `tokyonight` |
| `DNVIM_UNDO` | `1` | Share undo history with this host's nvim (`~/.local/state/nvim/undo`); `0` keeps nothing on the host |

## Notes

- Only the target directory is mounted; files outside it are not reachable
- Undo files contain edited content; use `DNVIM_UNDO=0` on machines you do not own
- shada and sessions are discarded on exit
- Clipboard uses OSC 52; iTerm2 needs Settings → General → Selection → Applications in terminal may access clipboard
- Update the image: `docker pull <NVIM_IMAGE>`
- `worker.js` serves this repo at `nvim.ronchang.io` (Cloudflare Worker)
