personal setup for shell/nvim etc.

# Shell
`zsh` is used, with `ohmyzsh`
### Plugins:
- zsh-auto-suggestions (need clone github)


# linking the tmux and neovim config
`ln -s ~/setup/tmux.conf ~/.tmux.conf`
`ln -s ~/setup/nvim ~/.config/nvim`
`ln -s ~/setup/zshrc ~/.zshrc`

## misc:
1. lazy.nvim has issue with using fzf native with telescope. solution 
  `cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
  cmake --build build --config Release`
