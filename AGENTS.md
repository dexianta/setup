# Repository Guidelines

## Project Structure & Module Organization
- The workspace stores personal shell/Neovim assets: `nvim/`, `tmux.conf`, `zshrc`, `dexian.zsh-theme`, and `README.md` at the root for quick reference.
- `nvim/init.lua` stitches together modules inside `nvim/lua/`; each feature (e.g., `lsp`, `cmp-cfg`, `gitsign-cfg`) should stay in its own file so `require("<name>")` keeps working.
- Keep helper files (like `tags.lua`) beside the module that uses them to avoid duplicated logic when Neovim loads the workspace.

## Build, Test, and Development Commands
- Apply the configuration with the README symlink commands: `ln -s ~/setup/nvim ~/.config/nvim`, `ln -s ~/setup/tmux.conf ~/.tmux.conf`, and `ln -s ~/setup/zshrc ~/.zshrc` so the runtime sees this repository.
- After cloning, run `nvim` once to let Lazy.nvim install plugins, and when Telescope FZF native fails rebuild it with `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release` from `~/.local/share/nvim/lazy/telescope-fzf-native.nvim`.
- Reload edited configs by running `tmux source-file ~/.tmux.conf` and `source ~/.zshrc` in your shell.

## Coding Style & Naming Conventions
- Lua files use two-space indentation, descriptive module names (suffix `-cfg` is normal for plugin settings), and short bootstrapping code in `init.lua` that just calls `require()` helpers.
- Keep shell snippets tidy: group third-party additions, document why a plugin is enabled, and rely on the existing `dexian.zsh-theme` prompt instead of ad hoc themes.
- Prefer explicit helper names for keymaps or custom commands to align with the current `lua/` layout and avoid anonymous tables that are hard to trace.

## Testing Guidelines
- There is no automated suite; validate changes manually by launching `nvim` to confirm plugin/keymap behavior and by sourcing `~/.zshrc` or reloading `tmux` to check shell bindings.
- When touching helper scripts such as `tags.lua`, exercise the corresponding Neovim command (e.g., `:AddTags`) to ensure it still runs.

## Commit & Pull Request Guidelines
- Commit messages follow the existing short, lowercase verb phrases like `remove null-ls` or `replace null-ls with none-ls`; keep subjects focused on the change and mention the area affected (for example, `nvim: stabilize spellcheck`).
- Pull requests should summarize the change, explain why it matters, list any manual verification steps, and link related issues or future follow-ups.

## Security & Configuration Tips
- Keep sensitive data out of this repo; anything that belongs in `~/.local/share/nvim` or other system paths stays outside version control.
- Back up original `~/.zshrc` and `~/.tmux.conf` before symlinking (`mv ~/.zshrc ~/.zshrc.bak`) so you can recover if a config behaves differently.
