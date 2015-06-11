#!/usr/bin/env bash

########## Params setup

# APP_PATH
APP_PATH=`pwd`

# color params
dot_color_none="\033[0m"
dot_color_dark="\033[0;30m"
dot_color_dark_light="\033[1;30m"
dot_color_red="\033[0;31m"
dot_color_red_light="\033[1;31m"
dot_color_green="\033[0;32m"
dot_color_green_light="\033[1;32m"
dot_color_yellow="\033[0;33m"
dot_color_yellow_light="\033[1;33m"
dot_color_blue="\033[0;34m"
dot_color_blue_light="\033[1;34m"
dot_color_purple="\033[0;35m"
dot_color_purple_light="\033[1;35m"
dot_color_cyan="\033[0;36m"
dot_color_cyan_light="\033[1;36m"
dot_color_gray="\033[0;37m"
dot_color_gray_light="\033[1;37m"

########## Basic setup
function msg(){
  printf '%b\n' "$1${dot_color_none}" >&2
}
function prompt(){
  printf '%b' "${dot_color_purple} [+] $1${dot_color_none} "
}
function step(){
  msg "${dot_color_yellow} [→] $1"
}
function info(){
  msg "${dot_color_cyan} [>] $1"
}
function success(){
  msg "${dot_color_green} [✓] $1"
}
function error(){
  msg "${dot_color_red_light} [✗] $1"
}

function is_file_exists(){
  [[ -e "$1" ]] && return 0 || return 1
}
function is_dir_exists(){
  [[ -d "$1" ]] && return 0 || return 1
}
function is_prog_exists(){
  if hash "$1" 2>/dev/null; then
    return 0
  else
    return 1
  fi;
}

function is_platform(){
  [[ `uname` = "$1" ]] && return 0 || return 1
}
function is_linux(){
  ( is_platform Linux ) && return 0 || return 1
}
function is_mac(){
  ( is_platform Darwin ) && return 0 || return 1
}

function lnif(){
  if [ -e "$1" ]; then
    info "Linking $1 to $2"
    ln -sf "$1" "$2"
  fi;
}

function sync_repo(){
  local repo_uri=$1
  local repo_path=$2
  local repo_branch=${3:-master}
  local repo_name=${1:19} # length of (https://github.com/)

  if ( ! is_dir_exists "$repo_path" ); then
    info "Cloning $repo_name ..."
    mkdir -p "$repo_path"
    git clone --depth 1 --branch "$repo_branch" "$repo_uri" "$repo_path"
    success "Successfully cloned $repo_name."
  else
    info "Updating $repo_name ..."
    cd "$repo_path" && git pull origin "$repo_branch"
    success "Successfully updated $repo_name."
  fi;

  if ( is_file_exists "$repo_path/.gitmodules" ); then
    info "Updating $repo_name submodules ..."
    cd "$repo_path"
    git submodule update --init --recursive
    success "Successfully updated $repo_name submodules."
  fi;
}

########## Setup functions

function usage(){

  if ( ! is_mac ) && ( ! is_linux ); then
    error "Sorry. Only *Linux* and *MAC* are supported"
    exit
  fi;

  echo
  echo 'Usage: install.sh [tasks]'
  echo
  echo 'Tasks:'
  printf "${dot_color_green}\n"
  echo '    0) all  ==> do all things below'
  echo '    1) vimrc'
  echo '    2) gitconfig'
  echo '    3) astylerc'
  echo '    4) sublime'
  echo '    5) zsh'
  echo '    6) tmux'
  printf "${dot_color_none}\n"
  echo
}

function install_vim_YouCompleteMe(){
  step "Installing vim YouCompleteMe plugin ..."

  # install python package manager pip
  if ( ! is_prog_exists pip ); then

    info "Installing pip for you..."

    mkdir -p "${APP_PATH}/.tmp"
    wget https://bootstrap.pypa.io/get-pip.py -O "${APP_PATH}/.tmp/get-pip.py"
    chmod +x "${APP_PATH}/.tmp/get-pip.py"
    sudo "${APP_PATH}/.tmp/get-pip.py"
    rm -rf "${APP_PATH}/.tmp"

    success "Successfully installed pip."
  fi;

  # install pynvim module for neovim
  if ( ! is_prog_exists pynvim ); then
    info "Installing pynvim for YouCompleteMe plugin ..."
    sudo pip install neovim
    success "Successfully installed pynvim."
  fi;

  # fetch or update YouCompleteMe
  sync_repo "https://github.com/Valloric/YouCompleteMe.git" \
            "${APP_PATH}/vim/bundle/YouCompleteMe"

  # compile libs for YouCompleteMe
  if ( ! is_file_exists "${APP_PATH}/vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ) || ( ! is_file_exists "${APP_PATH}/vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so" ); then
    info "Fetching and compiling YouCompleteMe libs ..."
    cd "${APP_PATH}/vim/bundle/YouCompleteMe"
    ./install.sh --clang-completer
  fi;
}

function install_vimrc(){

  step "Installing vimrc ..."

  sync_repo "https://github.com/gmarik/Vundle.vim.git" \
            "${APP_PATH}/vim/bundle/Vundle.vim"

  sync_repo "https://github.com/powerline/fonts.git" \
            "${APP_PATH}/vim/powerline-fonts"
  info "Installing powerline-fonts ..."
  cd "${APP_PATH}/vim/powerline-fonts"
  ./install.sh
  error "When install completed, please set your terminal to use powerline fonts for *Non-ASCII font*"

  info "Installing vimrc and bundle configs ..."
  lnif "${APP_PATH}/vim" "$HOME/.vim"
  lnif "${APP_PATH}/vim/vimrc" "$HOME/.vimrc"

  # install YouCompleteMe plugin
  install_vim_YouCompleteMe

  info "Installing vim bundles ..."
  vim +PluginInstall +qall

  if ( is_prog_exists nvim ); then
    step "Installing vimrc for neovim ..."
    lnif "${APP_PATH}/vim" "$HOME/.nvim"
    lnif "${APP_PATH}/vim/vimrc" "$HOME/.nvimrc"
  fi;

  success "Successfully installed vimrc and bundles."
}

function install_sublime(){
  if ( is_linux ); then
    SUBLIMEPATH="$HOME/.config/sublime-text-2"
  elif ( is_mac ); then
    SUBLIMEPATH="$HOME/Library/Application Support/Sublime Text 2"
  else
    error "Can't detect your platform. This support 'Linux' and 'Darwin' only"
    exit
  fi;

  step "Installing sublime ..."

  sync_repo "https://github.com/Treri/sublime-monokai-custom.git" \
            "${APP_PATH}/sublime/monokai-custom"

  info "Installing sublime Preference and Monokai-custom theme ..."
  lnif "${APP_PATH}/sublime/monokai-custom" "${SUBLIMEPATH}/Packages/User/monokai-custom"
  lnif "${APP_PATH}/sublime/Preferences.sublime-settings" "${SUBLIMEPATH}/Packages/User/Preferences.sublime-settings"

  success "Successfully installed sublime Preference and Monokai-custom theme"
}

function install_gitconfig(){
  step "Installing gitconfig ..."
  lnif "${APP_PATH}/gitconfig" "$HOME/.gitconfig"

  info "Now config your name and email for git."

  USER=`whoami`
  prompt "What's your git username? (${USER}) "
  read USERNAME
  if [ "${USERNAME}" = "" ]; then
    USERNAME=${USER}
  fi;
  git config --global user.name ${USERNAME}

  prompt "What's your git email? (${USERNAME}@example.com) "
  read EMAIL
  if [ "$EMAIL" = "" ]; then
    EMAIL=${USER}@example.com
  fi;
  git config --global user.email ${EMAIL}

  if ( is_mac ); then
    git config --global credential.helper osxkeychain
  fi;

  success "Successfully installed gitconfig."
}

function install_astylerc(){
  step "Installing astylerc ..."

  lnif "${APP_PATH}/astylerc" "$HOME/.astylerc"

  success "Successfully installed astylerc."
}

function install_zsh(){
  if ( is_prog_exists zsh ); then
    step "Installing zsh ..."
  else
    error "No Zsh found! Please install zsh first"
    exit
  fi;

  ZSHPATH=`which zsh`

  sync_repo "https://github.com/robbyrussell/oh-my-zsh.git" \
            "${APP_PATH}/zsh/oh-my-zsh"

  sync_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
            "${APP_PATH}/zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

  info "Installing zsh and oh-my-zsh ..."

  lnif "${APP_PATH}/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"
  lnif "${APP_PATH}/zsh/zshrc" "$HOME/.zshrc"

  info "Time to change your default shell to zsh!"
  chsh -s ${ZSHPATH}

  success "Successfully installed zsh and oh-my-zsh."
  cd ${APP_PATH}
  /usr/bin/env zsh
  source $HOME/.zshrc
}

function install_zshcfg(){
  step "Installing zsh configs ..."

  lnif "${APP_PATH}/zsh/zsh.alias" "$HOME/.zsh.alias"
  lnif "${APP_PATH}/zsh/zsh.paths" "$HOME/.zsh.paths"
  lnif "${APP_PATH}/zsh/zsh.sources" "$HOME/.zsh.sources"

  source "$HOME/.zsh.alias"
  source "$HOME/.zsh.paths"
  source "$HOME/.zsh.sources"

  success "Successfully installed zsh configs"
}

function install_tmux(){
  if ( is_prog_exists tmux ); then
    step "Installing tmux configs ..."
  else
    error "No tmux found! Please install tmux first"
    return
  fi;

  sync_repo "https://github.com/tmux-plugins/tpm" \
            "${APP_PATH}/tmux/plugins/tpm"

  # tmux中的vim无法使用系统的粘贴板, 安装reattach-to-user-namespace修复
  if ( is_mac ); then
    if( ! is_prog_exists reattach-to-user-namespace ); then
      if ( is_prog_exists brew ); then
        brew install reattach-to-user-namespace
      else
        error "Maybe you should install reattach-to-user-namespace for vim in tmux"
      fi;
    fi;
  fi;

  info "Installing tmux configs ..."
  lnif "${APP_PATH}/tmux" "$HOME/.tmux"
  lnif "${APP_PATH}/tmux/tmux.conf" "$HOME/.tmux.conf"

  success "Please run tmux and use prefix-I to install tmux plugins or reload your tmux.conf"
}

if [ $# = 0 ]; then
  usage
else
  for arg in $@; do
    case $arg in
      all)
        install_vimrc
        install_gitconfig
        install_astylerc
        install_sublime
        install_tmux
        install_zsh
        ;;
      vimrc)
        install_vimrc
        ;;
      gitconfig)
        install_gitconfig
        ;;
      astylerc)
        install_astylerc
        ;;
      sublime)
        install_sublime
        ;;
      zsh)
        install_zsh
        ;;
      zshcfg)
        install_zshcfg
        ;;
      tmux)
        install_tmux
        ;;
      *)
        echo
        error "Invalid params ${arg}"
        usage
        ;;
    esac;
  done;
fi;
