# The context of this script is you are in a machine that has source code to be directly worked on
sudo apt-get update
sudo apt-get install ripgrep
sudo apt-get install fd-find
sudo apt-get install stow
sudo apt-get install fzf

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo rm nvim-linux*


# Check for modification in .bashrc
if ! grep -qF 'export PATH=$PATH:/opt/nvim-linux64/bin' ~/.bashrc; then
    echo "Configuring neovim to path in bashrc..."
    echo 'export PATH=$PATH:/opt/nvim-linux64/bin' >> ~/.bashrc
else
    echo 'Skipping PATH modification for neovim in ~/.bashrc as it already exists on system...'
fi

# Check for modification in .zshrc
if ! grep -qF 'export PATH=$PATH:/opt/nvim-linux64/bin' ~/.zshrc; then
    echo "Configuring neovim to path in zshrc..."
    echo 'export PATH=$PATH:/opt/nvim-linux64/bin' >> ~/.zshrc
else
    echo 'Skipping PATH modification for neovim in ~/.zshrc as it already exists on system...'
fi

# sudo chmod +x ./setup_dev_stow.sh
# ./setup_dev_stow.sh
