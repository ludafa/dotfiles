#!/bin/sh

zshrc() {
  echo "==========================================================="
  echo "             installing amix/vimrc                         "
  echo "-----------------------------------------------------------"
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh

  echo "==========================================================="
  echo "             install zsh theme & plugins (Homebrew)        "
  echo "-----------------------------------------------------------"
  brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting fzf zoxide fnm

  echo "==========================================================="
  echo "             import zshrc                                  "
  echo "-----------------------------------------------------------"
  cat ./zshrc > ~/.zshrc

  echo "==========================================================="
  echo "             import powerlevel10k                          "
  echo "-----------------------------------------------------------"
  cat ./p10k.zsh > ~/.p10k.zsh

  echo "==========================================================="
  echo "             import vimrc                                  "
  echo "-----------------------------------------------------------"
  cat ./vimrc.vim > ~/.vim_runtime/my_configs.vim

  echo "==========================================================="
  echo "             import git config                             "
  echo "-----------------------------------------------------------"
  cat ./gitconfig > ~/.gitconfig
}

karabiner() {
  echo "==========================================================="
  echo "             link karabiner-elements config                "
  echo "-----------------------------------------------------------"
  # link the whole directory: Karabiner rewrites karabiner.json on save, which breaks a file symlink
  src="$(cd "$(dirname "$0")" && pwd)/karabiner"
  dst="$HOME/.config/karabiner"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
  fi
  mkdir -p "$HOME/.config"
  ln -s "$src" "$dst"
  launchctl kickstart -k "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server" 2>/dev/null || true
}

zshrc

karabiner
