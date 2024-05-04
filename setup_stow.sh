rm -rf ~/.config/nvim
rm ~/.bashrc
rm ~/.zshrc
rm ~/.wezterm.lua

if [ ! -d ~/.config/nvim ]; then
    sudo mkdir ~/.config/nvim
fi

stow bash
stow wezterm
sudo stow -t ~/.config/nvim neovim
