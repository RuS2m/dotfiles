#!/bin/zsh

if [ ! -d $HOME/.config/ ]; then
    mkdir "$HOME/.config"
fi

if [ ! -d $HOME/.config/nvim/ ]; then
	mkdir "$HOME/.config/nvim"
fi

ln -sf "$HOME"/dotfiles/nvim/init.lua "$HOME"/.config/nvim/init.lua
echo "Linked init.lua"

if [ ! -d $HOME/.config/nvim/lua ]; then
    mkdir "$HOME/.config/nvim/lua"
fi

declare -a LUA_FILES=("opts" "plugins")

for lua_file in "${LUA_FILES[@]}"; do
    ln -sf "$HOME/dotfiles/nvim/lua/${lua_file}.lua" "$HOME/.config/nvim/lua/${lua_file}.lua"
    echo "Linked ${lua_file}.lua"
done

