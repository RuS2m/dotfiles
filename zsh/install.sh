#!/bin/zsh

cp "$HOME"/dotfiles/zsh/agnoster.zsh-theme "$HOME"/.oh-my-zsh/themes/agnoster.zsh-theme
echo "Copied modified agnoster theme configuration" 

ln -sf "$HOME"/dotfiles/zsh/.zshrc "$HOME"/.zshrc
echo "Linked .zshrc file"
