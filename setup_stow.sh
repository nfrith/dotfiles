if [ ! -d ~/.config/nvim ]; then
    sudo mkdir ~/.config/nvim
fi

sudo stow -t ~/.config/nvim neovim
