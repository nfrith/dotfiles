if [ -d ~/.config/nvim ]; then
    echo 'removing ~/.config/nvim'
    sudo rm -rf ~/.config/nvim
    sudo mkdir ~/.config/nvim
fi

if [ -f ~/.bashrc ]; then
    echo 'removing ~/.bashrc'
    sudo rm ~/.bashrc
fi

if [ -f ~/.zshrc ]; then
    echo 'removing ~/.zshrc'
    sudo rm ~/.zshrc
fi

if [ -f ~/.wezterm.lua ]; then
    echo 'removing ~/.wezterm.lua'
    sudo rm ~/.wezterm.lua
fi


echo 'applying stow'
stow bash
stow wezterm
sudo stow -t ~/.config/nvim neovim
echo 'done applying stow'
