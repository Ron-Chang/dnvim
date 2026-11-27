# dnvim

Portable Neovim in a container: plugins, LSP servers and treesitter parsers preinstalled.
Only needs Docker on the host.

## Usage

One-off:

```bash
curl -sL nvim.ronchang.io | bash                     # current directory, dashboard
curl -sL nvim.ronchang.io | bash -s -- WORKPATH      # directory: dashboard there; file: open it
```

Install as a command (`~/.local/bin/dnvim`, override with `DNVIM_BIN`); rerun to update:

```bash
curl -sL nvim.ronchang.io/install | sh
dnvim WORKPATH
```

Uninstall: `rm ~/.local/bin/dnvim`

Inspect before running: `curl -sL nvim.ronchang.io | less`, `curl -sL nvim.ronchang.io/install | less`

## Environment

| Variable | Default | Description |
|---|---|---|
| `NVIM_IMAGE` | `ronhsienchang/dnvim:latest` | Image to run |
| `NVIM_THEME` | `tokyonight` | `gruvbox`, `gruvbox-material`, `monokai`, `monokai-pro`, `nord`, `onedark`, `tokyonight` |
| `DNVIM_STATE` | `1` | Share undo and shada (recent files, registers, command history) with this host's nvim (`~/.local/state/nvim`); `0` keeps nothing on the host |

## Notes

- Only the target directory is mounted; files outside it are not reachable
- Undo files and shada registers contain edited content; use `DNVIM_STATE=0` on machines you do not own
- Recent files outside the mounted directory are listed by the host nvim only
- Sessions are discarded on exit
- Clipboard uses OSC 52; iTerm2 needs Settings → General → Selection → Applications in terminal may access clipboard
- Update the image: `docker pull <NVIM_IMAGE>`
- `worker.js` serves this repo at `nvim.ronchang.io`; Cloudflare Workers Builds deploys it on push (`wrangler.jsonc`)
