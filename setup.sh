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

function install_oh_my_zsh() {
    # Install oh-my-zsh
    export ZSH="$HOME/.oh-my-zsh"
    if [ ! -d $ZSH ]; then
        echo "\tInstalling..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
	./zsh/install.sh
}

function install_brew() {
    brew_version="$(brew -v)"
    if [[ $brew_version != Homebrew* ]]; then
        echo "\tInstalling..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
    fi
}

function install_tmux() {
    if [ ! -d $TMUX ]; then
        echo "\tInstalling..."
        if [ "$1" = "Mac" ]; then
            brew install tmux
        elif [ "$1" = "Linux" ]; then
            sudo apt install tmux
        fi
    fi
    #TODO: tmux configuration
}

function install_neovim() {
    nvim_version="$(nvim --version)"
    if [[ $nvim_version != NVIM* ]]; then
        echo "\tInstalling..."
        if [ "$1" = "Mac" ]; then
            brew install neovim
        elif [ "$1" = "Linux" ]; then
            sudo apt-get install neovim
        fi
        # Install packer
        git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
        # Install packer dependencies
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    fi

    # Symlink novim config
    ./nvim/install.sh
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
    if [[ "$machine" == "Mac" ]]; then
        echo "🍺 HomeBrew setup..."
        install_brew
    fi
    echo "🍫 tmux setup..."
    install_tmux "$machine"
    echo "🇳 neovim setup..."
    install_neovim "$machine"

    echo "${GREEN}Setup finished!${NC}"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    if [[ "debug" = $1 ]]; then
        DEBUG=1
    else
        DEBUG=0
    fi

    main "$@"
fi
