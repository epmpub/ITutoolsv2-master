Linux
Pre-built archives
The Releases page provides pre-built binaries for Linux systems.

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
After this step add this to ~/.bashrc:

export PATH="$PATH:/opt/nvim-linux64/bin"

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}


git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

nvim

sudo apt install build-essential


$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz


export PATH=$PATH:/usr/local/go/bin

$ go version

