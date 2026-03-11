#!/bin/zsh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function determine_machine() {
    sysname="$(uname -s)"
    case "${sysname}" in
        Linux*)     machine=Linux;;
        Darwin*)    machine=Mac;;
        CYGWIN*)    machine=Cygwin;;
        MINGW*)     machine=MinGw;;
        *)          machine="UNKNOWN:${unameOut}"
    esac
    echo $machine
}

# to use `has_cmd nvim`, it would check that the name resolves successfully
function has_cmd() {
    [ $# -gt 0 ] || return 1
    command -v -- "$1" >/dev/null 2>&1
}

# to use `can_run nvim --version`, it would check if the command succeeds
function can_run() {
    "$@" >/dev/null 2>&1
}

function has_brew() {
    has_cmd brew && can_run brew -v
}

function install_oh_my_zsh() {
    # TODO: replace with fish
    # Install oh-my-zsh (cringe, to be removed immediately)
    if ! has_cmd zsh || ! can_run zsh --version; then
        echo "\tInstalling..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
	./zsh/install.sh
}

function install_rustup() {
    if ! has_cmd rustup || ! can_run rustup -V; then
        echo "\tInstalling..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        . "$HOME/.cargo/env"
        rustup toolchain install stable
        rustup component add rust-analyzer
    fi
}

function install_ripgrep() {
    if has_brew; then
        echo "Installing ripgrep using Homebrew..."
        brew install ripgrep
    elif has_cmd apt; then
        echo "Installing ripgrep using apt..."
        sudo apt-get update && sudo apt-get install -y ripgrep
    elif has_cmd pacman; then
        echo "Installing ripgrep using pacman..."
        sudo pacman -S ripgrep
    else
        echo "Please install ripgrep manually. Visit https://github.com/BurntSushi/ripgrep#installation for instructions."
    fi
}

function install_brew() {
    if ! has_brew; then
        echo "\tInstalling..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
    fi
}

function install_gdb() {
    if ! has_cmd gdbserver || ! has_cmd gdb; then
        if has_brew; then
            brew install gdb
        elif [ "$1" = "Linux" ]; then
            sudo apt-get install gdb gdbserver
        fi
    fi
	./gdb/install.sh
}

function install_clangd() {
    if ! has_cmd clangd || ! can_run clangd --version; then
        echo "\tInstalling..."
        if has_brew; then
            brew install llvm
            brew link --force llvm
            brew install lld
        elif [ "$1" = "Linux" ]; then
            sudo apt update
            sudo apt install clangd
        fi
    fi
    if [ ! -d $HOME/.clang-format ]; then
        touch "$HOME/.clang-format";
        ln -sf "$HOME"/dotfiles/clangd/.clang-format "$HOME"/.clang-format
        echo "Linked .clang-format"
    fi
}

function install_tmux() {
    if ! has_cmd tmux || ! can_run tmux -V; then
        echo "\tInstalling..."
        if has_brew; then
            brew install tmux
        elif [ "$1" = "Linux" ]; then
            sudo apt install tmux
        fi
    fi
    if [ ! -d $HOME/.tmux.conf ]; then
        touch "$HOME/.tmux.conf";
        ln -sf "$HOME"/dotfiles/tmux/.tmux.conf "$HOME"/.tmux.conf
        echo "Linked .tmux.conf"
    fi
}

function install_neovim() {
    if ! has_cmd nvim || ! can_run nvim --version; then
        echo "\tInstalling..."
        if has_brew; then
            brew install neovim
        elif [ "$1" = "Linux" ]; then
            # _Sometimes_ apt is prohibited to use on work, rely on yum in that cases
            if has_cmd apt-get && can_run apt-get --version; then
                echo "\t\tTrying out apt-get..."
                sudo apt-get install neovim
            elif has_cmd yum && can_run yum version; then
                echo "\t\tTrying out yum..."
                yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
                yum install -y neovim python3-neovim
            fi

            # Checking if the nvim was successfully installed (_sometimes_ certain security restrictions doesn't allow installing it)
            if ! has_cmd nvim || ! can_run nvim --version; then
                echo "\t\t${RED}PUT YOUR SEATBELT ON! ${NC}Downloading pre-built archive..."
                # Last resort: downloading neovim from pre-built archive
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
                sudo rm -rf /opt/nvim
                sudo tar -C /opt -xzf nvim-linux64.tar.gz
                export PATH="$PATH:/opt/nvim-linux64/bin"
            fi
        fi
        # Install packer
        git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	# Symlink neovim config
	./nvim/install.sh
        # Install packer dependencies
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    else
        # Symlink neovim config
        ./nvim/install.sh
        # Install packer dependencies
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    fi
}

function main() {
    machine=$(determine_machine)
    if [[ "$machine" != "Mac" && "$machine" != "Linux" ]]; then
        echo "${RED}The script is not configured for the machine of type ${machine}${NC}"
        return 1
    fi

    echo "Setting up your ${machine}..."


    echo "🫢 oh-my-zsh setup..."
    install_oh_my_zsh
    echo "🍺 HomeBrew setup..."
    install_brew
    echo "🍫 tmux setup..."
    install_tmux "$machine"
    echo "🎵 clangd setup..."
    install_clangd
    echo "🐞🐠 gdb setup..."
    install_gdb
    echo "🪦 ripgrep setup..."
    install_ripgrep
    echo "🦀 rust setup..."
    install_rustup
    echo "✌️  neovim setup..."
    install_neovim "$machine"

    echo "${GREEN}Setup finished!${NC}"
}

main
