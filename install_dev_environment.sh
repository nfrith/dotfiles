#!/bin/bash

# The context of this script is you are in a machine that has source code to be directly worked on
sudo apt-get update
sudo apt-get install -y ripgrep fd-find stow fzf

# Check if nvm is installed
if ! command -v nvm &> /dev/null; then
  echo "nvm not found, installing..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  # Source nvm after installation for immediate use
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  # [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  # Install Node.js LTS version
  nvm install --lts 

else
  echo "nvm already installed."
fi

# get typescript server for lsp
npm install -g typescript-language-server
npm install -g neovim
npm install -g vscode-langservers-extracted
cargo install htmx-lsp

# Download and install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo rm nvim-linux*


# Check for modification in .bashrc
# if ! grep -qF 'export PATH=$PATH:/opt/nvim-linux64/bin' ~/.bashrc; then
#     echo "Configuring neovim to path in bashrc..."
#     echo 'export PATH=$PATH:/opt/nvim-linux64/bin' >> ~/.bashrc
# else
#     echo 'Skipping PATH modification for neovim in ~/.bashrc as it already exists on system...'
# fi

# Check for modification in .zshrc
# if ! grep -qF 'export PATH=$PATH:/opt/nvim-linux64/bin' ~/.zshrc; then
#     echo "Configuring neovim to path in zshrc..."
#     echo 'export PATH=$PATH:/opt/nvim-linux64/bin' >> ~/.zshrc
# else
#     echo 'Skipping PATH modification for neovim in ~/.zshrc as it already exists on system...'
# fi

# Configure PATH in .bashrc and .zshrc (DRY principle)
for rcfile in ~/.bashrc ~/.zshrc; do
  if ! grep -qF 'export PATH=$PATH:/opt/nvim-linux64/bin' "$rcfile"; then
    echo "Configuring neovim path in $rcfile..."
    echo 'export PATH=$PATH:/opt/nvim-linux64/bin' >> "$rcfile"
  else
    echo "Skipping PATH modification for neovim in $rcfile (already exists)..."
  fi
done


# sudo chmod +x ./setup_dev_stow.sh
# ./setup_dev_stow.sh
