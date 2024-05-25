if [ -d ~/.config/nvim ]; then
    echo 'removing ~/.config/nvim'
    sudo rm -rf ~/.config/nvim
fi

sudo mkdir ~/.config/nvim

echo 'applying stow'
sudo stow -t ~/.config/nvim neovim
echo 'done applying stow'
