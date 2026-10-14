#!/bin/sh

zshrc() {
  echo "==========================================================="
  echo "             installing amix/vimrc                         "
  echo "-----------------------------------------------------------"
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh

  echo "==========================================================="
  echo "             install zsh plugins                           "
  echo "-----------------------------------------------------------"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo "==========================================================="
  echo "             cloning powerlevel10k                         "
  echo "-----------------------------------------------------------"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

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

  echo "==========================================================="
  echo "             installing fnm                                "
  echo "-----------------------------------------------------------"
  curl -fsSL https://fnm.vercel.app/install | bash
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

# make directly highlighting readable - needs to be after zshrc line
echo "" >> ~/.zshrc
echo "# remove ls and directory completion highlight color" >> ~/.zshrc
echo "_ls_colors=':ow=01;33'" >> ~/.zshrc
echo 'zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"' >> ~/.zshrc
echo 'LS_COLORS+=$_ls_colors' >> ~/.zshrc

karabiner
