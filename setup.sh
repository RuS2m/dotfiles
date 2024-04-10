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
            apt_get_version="$(apt-get --version)"
            # _Sometimes_ apt is prohibited to use on work, rely on yum in that cases
            yum_version="$(yum version)"
            if [[ $apt_get_version = apt* ]]; then
                echo "\t\tTrying out apt-get..."
                sudo apt-get install neovim
            elif [[ $yum_version = Loaded* ]]; then
                echo "\t\tTrying out yum..."
                yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
                yum install -y neovim python3-neovim
            fi

            # Checking if the nvim was successfully installed (_sometimes_ certain security restrictions doesn't allow installint it)
            nvim_version="$(nvim --version)"
            if [[ $nvim_version != NVIM* ]]; then
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
    if [[ "$machine" == "Mac" ]]; then
        echo "🍺 HomeBrew setup..."
        install_brew
    fi
    echo "🍫 tmux setup..."
    install_tmux "$machine"
    echo "✌️  neovim setup..."
    install_neovim "$machine"

    echo "${GREEN}Setup finished!${NC}"
}

main
