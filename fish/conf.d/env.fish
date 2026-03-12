set -gx EDITOR nvim

# CARGO CONFIGS
fish_add_path ~/.cargo/bin

# DEVCONTAINERS CONFIGS
fish_add_path $HOME/.devcontainers/bin

# C++ CONFIGS
set -gx CPPFLAGS "-I/usr/local/opt/llvm/include"
fish_add_path /usr/local/opt/llvm/bin
set -gx LDFLAGS "-L/usr/local/opt/llvm/lib/c++ -L/usr/local/opt/llvm/lib/unwind -lunwind"

# pipx
fish_add_path $HOME/.local/bin
