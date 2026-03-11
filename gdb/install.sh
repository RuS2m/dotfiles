#!/bin/zsh

CUSTOM_GDB_DIR="$HOME/gdb/libcxx"
mkdir -p "$CUSTOM_GDB_DIR"

echo "Installing libc++ pretty printer"
curl -fL "https://raw.githubusercontent.com/llvm/llvm-project/main/libcxx/utils/gdb/libcxx/printers.py" -o "$CUSTOM_GDB_DIR/printers.py"

ln -sf "$HOME"/dotfiles/gdb/.gdbinit "$HOME"/.gdbinit
echo "Installed printers and linked .gdbinit file"
