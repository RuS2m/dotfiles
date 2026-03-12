#!/bin/bash

if [ ! -d $HOME/.config/ ]; then
    mkdir "$HOME/.config"
fi

if [ ! -d $HOME/.config/fish/ ]; then
	mkdir "$HOME/.config/fish"
fi

ln -sf  "$HOME"/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf  "$HOME"/dotfiles/fish/conf.d ~/.config/fish/conf.d
ln -sf  "$HOME"/dotfiles/fish/functions ~/.config/fish/functions
echo "Linked all fish configurations"

echo "Setting up fish as default terminal"
chsh -s $(which fish)
