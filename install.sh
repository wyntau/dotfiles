#!/bin/bash

# go root
ROOT=`pwd`
function go_root(){
  cd ${ROOT}
}

##### print info #####
STEP_PREFIX='\033[0;33m'
INFO_PREFIX='\033[0;36m'
SUCCESS_PREFIX='\033[0;32m'
ERR_PREFIX='\033[1;31m'
PROMPT_PREFIX='\033[0;35m'
ALL_SUFFIX='\033[0m'

function step(){
  echo -e "${STEP_PREFIX}==> $1${ALL_SUFFIX}"
}

function info(){
  echo -e "${INFO_PREFIX}$1${ALL_SUFFIX}"
}

function success(){
  echo -e "${SUCCESS_PREFIX}$1${ALL_SUFFIX}"
}

function err(){
  echo -e "${ERR_PREFIX}$1${ALL_SUFFIX}"
}

function prompt(){
  printf "${PROMPT_PREFIX}$1${ALL_SUFFIX}"
}

##### file and directory detect ######
function is_file_exists(){
  local f="$1"
  [[ -f "${f}" ]] && return 0 || return 1
}

function is_dir_exists(){
  local d="$1"
  [[ -d "${d}" ]] && return 0 || return 1
}

function is_prog_exists(){
  local p="$1"
  if hash "${p}" 2>/dev/null; then
    return 0
  else
    return 1
  fi;
}

##### platform detect #####
PLATFORM=`uname`
function is_platform(){
  local p="$1"
  [[ $PLATFORM = "${p}" ]] && return 0 || return 1
}

function is_linux(){
  ( is_platform Linux ) && return 0 || return 1
}

function is_mac(){
  ( is_platform Darwin ) && return 0 || return 1
}

if ( is_linux ); then
  SUBLIMEPATH="$HOME/.config/sublime-text-2"
elif ( is_mac ); then
  SUBLIMEPATH="$HOME/Library/Application Support/Sublime Text 2"
else
  err "Can't detect your platform. This support 'Linux' and 'Darwin' only"
fi;

function usage(){
  echo
  echo 'Usage: install.sh [tasks]'
  echo
  echo 'Tasks:'
  printf ${SUCCESS_PREFIX}
  echo '    0) all  ==> do all things below'
  echo '    1) vimrc'
  echo '    2) gitconfig'
  echo '    3) astylerc'
  echo '    4) sublime'
  echo '    5) zsh'
  printf ${ALL_SUFFIX}
  echo
}

function install_vimrc(){

  step "Installing vimrc..."

  go_root

  if ( is_dir_exists vim/bundle/vundle ); then
    info "update vundle submodule"
    cd vim/bundle/vundle
    git pull origin master
  else
    info "init and update vundle submodule"
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
  fi;

  info "Installing vimrc and bundle configs"

  rm -rf ~/.vim
  info "Linking ${ROOT}/vim to ~/.vim"
  ln -s ${ROOT}/vim ~/.vim

  rm -rf ~/.vimrc
  info "Linking ${ROOT}/vim/vimrc to ~/.vimrc"
  ln -s ${ROOT}/vim/vimrc ~/.vimrc

  info "Installing vim bundles......"
  vim +BundleInstall +qall

  success "Install vimrc and bundles completed."
}

function install_sublime(){

  step "Installing sublime"

  go_root

  if ( is_dir_exists sublime/monokai-custom ); then
    info "update monokai-custom submodule..."
    cd sublime/monokai-custom
    git pull origin master
  else
    info "init and update monokai-custom submodule..."
    git clone https://github.com/Treri/sublime-monokai-custom.git sublime/monokai-custom
  fi;

  info "Installing sublime Preference and Monokai-custom theme......"

  rm -rf "${SUBLIMEPATH}/Packages/User/monokai-custom"
  info "Linking ${ROOT}/sublime/monokai-custom ${SUBLIMEPATH}/Packages/User/monokai-custom"
  ln -s ${ROOT}/sublime/monokai-custom "${SUBLIMEPATH}/Packages/User/monokai-custom"

  rm -rf "${SUBLIMEPATH}/Packages/User/Preferences.sublime-settings"
  info "Linking ${ROOT}/sublime/Preferences.sublime-settings to ${SUBLIMEPATH}/Packages/User/Preferences.sublime-settings"
  ln -s ${ROOT}/sublime/Preferences.sublime-settings "${SUBLIMEPATH}/Packages/User/Preferences.sublime-settings"

  success "Install sublime Preference and Monokai-custom theme completed."
}

USER=`whoami`
function install_gitconfig(){

  step "Installing gitconfig......"

  go_root

  rm -rf ~/.gitconfig
  info "Linking ${ROOT}/gitconfig to ~/.gitconfig"
  ln -s ${ROOT}/gitconfig ~/.gitconfig

  info "Now config your name and email for git."

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

  success "Install gitconfig completed."
}

function install_astylerc(){

  step "Installing astylerc......"

  go_root

  rm -rf ~/.astylerc
  info "Linking ${ROOT}/astylerc to ~/.astylerc"
  ln -s ${ROOT}/astylerc ~/.astylerc

  success "Install astylerc completed."
}

function install_zsh(){

  if ( is_prog_exists zsh ); then
    step "Installing zsh..."
  else
    err "No Zsh found! Please install zsh first"
    return
  fi;

  go_root

  ZSHPATH=`which zsh`

  if ( is_dir_exists zsh/oh-my-zsh ); then
    info "update oh-my-zsh..."
    cd zsh/oh-my-zsh
    git pull origin master
  else
    info "init and update oh-my-zsh..."
    git clone https://github.com/robbyrussell/oh-my-zsh.git zsh/oh-my-zsh
  fi;

  go_root
  if ( is_dir_exists zsh/oh-my-zsh/custom/plugins ); then
    if ( is_dir_exists zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting ); then
      info "update zsh-syntax-highlighting plugin..."
      cd zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
      git pull origin master
    else
      info "init and update zsh-syntax-highlighting plugin..."
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi;
  fi;

  info "Installing zsh and oh-my-zsh......"
  rm -rf ~/.oh-my-zsh
  rm -rf ~/.zshrc

  info "Linking ${ROOT}/zsh/oh-my-zsh to ~/.oh-my-zsh"
  ln -s ${ROOT}/zsh/oh-my-zsh ~/.oh-my-zsh

  info "Linking ${ROOT}/zsh/zshrc to ~/.zshrc";
  ln -s ${ROOT}/zsh/zshrc ~/.zshrc

  info "Time to change your default shell to zsh!"
  chsh -s ${ZSHPATH}

  success "Install zsh and oh-my-zsh completed."
  /usr/bin/env zsh
  source ~/.zshrc
}

function install_zshcfg(){

  step "Installing zsh configs..."

  go_root

  rm -rf ~/.zsh.alias
  rm -rf ~/.zsh.paths
  rm -rf ~/.zsh.sources

  info "Linking zsh configs";
  ln -s ${ROOT}/zsh/zsh.alias ~/.zsh.alias
  ln -s ${ROOT}/zsh/zsh.paths ~/.zsh.paths
  ln -s ${ROOT}/zsh/zsh.sources ~/.zsh.sources

  # source ~/.zsh.alias
  # source ~/.zsh.paths
  # source ~/.zsh.sources

  success "Install zsh configs success";
  success "Please open new termial to load configs";
}

function install_tmux(){

  if ( is_prog_exists tmux ); then
    step "Installing tmux configs..."
  else
    err "No tmux found! Please install tmux first"
    return
  fi;

  go_root

  if ( is_dir_exists tmux/plugins/tpm ); then
    info "update tpm..."
    cd tmux/plugins/tpm
    git pull origin master
  else
    info "init and update tpm..."
    git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm
  fi;

  info "Installing tmux configs..."
  rm -rf ~/.tmux
  rm -rf ~/.tmux.conf

  info "Linking ${ROOT}/tmux to ~/.tmux"
  ln -s ${ROOT}/tmux ~/.tmux

  info "Linking ${ROOT}/tmux/tmux.conf to ~/.tmux.conf";
  ln -s ${ROOT}/tmux/tmux.conf ~/.tmux.conf
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
        install_zsh
        install_tmux
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
        err "Invalid params ${arg}"
        usage
        ;;
    esac;
  done;
fi;


#none         = "\033[0m"
#black        = "\033[0;30m"
#dark_gray    = "\033[1;30m"
#red          = "\033[0;31m"
#light_red    = "\033[1;31m"
#green        = "\033[0;32m"
#light_green -= "\033[1;32m"
#brown        = "\033[0;33m"
#yellow       = "\033[1;33m"
#blue         = "\033[0;34m"
#light_blue   = "\033[1;34m"
#purple       = "\033[0;35m"
#light_purple = "\033[1;35m"
#cyan         = "\033[0;36m"
#light_cyan   = "\033[1;36m"
#light_gray   = "\033[0;37m"
#white        = "\033[1;37m"
