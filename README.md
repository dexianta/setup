personal setup for shell/nvim etc.

# Shell
`zsh` is used, with `ohmyzsh`
### Plugins:
- zsh-auto-suggestions (need clone github)


# linking the tmux and neovim config
- `ln -s ~/setup/tmux.conf ~/.tmux.conf`
- `ln -s ~/setup/nvim ~/.config/nvim`
- `ln -s ~/setup/zshrc ~/.zshrc`

## misc:
1. lazy.nvim has issue with using fzf native with telescope. solution 
  `cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
  cmake --build build --config Release`

## Jupyter notebooks
- Main workflow: edit Python scripts with Jupyter-style `# %%` cells. Opening a `.py` file that contains `# %%` auto-initializes a matching Molten/Jupyter kernel when possible.
- Neovim uses Molten, NotebookNavigator.nvim, image.nvim, jupytext.nvim, and quarto-nvim/otter for notebook editing.
- Install runtime dependencies before first use:
  - `python -m pip install pynvim jupyter_client ipykernel nbformat jupytext`
  - `brew install imagemagick`
- After Lazy installs Molten, run `:UpdateRemotePlugins`, restart Neovim, then check `:checkhealth molten`.
- Use `:NewNotebook path/name` to create a blank Python notebook. Existing `.ipynb` files open through Jupytext as percent-format Python files.
- Common mappings use the `<leader>j` prefix:
  - `<leader>ji` initializes a kernel.
  - `<leader>jc` runs the current `# %%` cell.
  - `<leader>jn` runs the current cell and moves to the next cell.
  - `<leader>jA` runs all cells.
  - `<leader>jb` runs the current cell and cells below it.
  - `<leader>jo` opens output.
  - `<leader>jE` exports outputs back to the notebook.
  - `]b` and `[b` move between cells.
