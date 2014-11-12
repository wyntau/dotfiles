#!/bin/bash

USER=`whoami`
ROOT=`pwd`
ZSHPATH=`which zsh`
SUBLIMEPATH=${SUBLIMEPATH:="$HOME/Library/Application Support/Sublime Text 2"}

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

STEP_PREFIX='\033[0;33m'
INFO_PREFIX='\033[0;36m'
SUCCESS_PREFIX='\033[0;32m'
ERR_PREFIX='\033[1;31m'
PROMPT_PREFIX='\033[0;35m'
ALL_SUFFIX='\033[0m'

function go_root(){
  cd ${ROOT}
}

function is_file_exists(){
  local f="$1"
  [[ -f "${f}" ]] && return 0 || return 1
}

function is_dir_exists(){
  local d="$1"
  [[ -d "${d}" ]] && return 0 || return 1
}

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
  if ( is_dir_exists vim/bundle/vundle ); then
    info "update vundle submodule"
    cd vim/bundle/vundle
    git pull origin master
    go_root
  else
    info "init and update vundle submodule"
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
  fi;

  info "Installing vimrc and bundle configs"

  rm -rf ~/.vim
  info "Linking ${ROOT}/vim to ~/.vim"
  ln -s ${ROOT}/vim ~/.vim

  for FILE in vimrc editorconfig; do
    rm -rf ~/.${FILE}
      info "Linking ${ROOT}/vim/${FILE} to ~/.${FILE}"
    ln -s ${ROOT}/vim/${FILE} ~/.${FILE}
  done;

  info "Installing vim bundles......"
  vim +BundleInstall +qall
  success "Install vimrc and bundles completed."
}

function install_sublime(){
  step "Installing sublime"
  if ( is_dir_exists sublime/monokai-custom ); then
    info "update monokai-custom submodule..."
    cd sublime/monokai-custom
    git pull origin master
    go_root
  else
    info "init and update monokai-custom submodule..."
    git clone https://github.com/Jeremial/sublime-monokai-custom.git sublime/monokai-custom
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

function install_gitconfig(){
  step "Installing gitconfig......"
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

  success "Install gitconfig completed."
}

function install_astylerc(){
  step "Installing astylerc......"
  rm -rf ~/.astylerc
  info "Linking ${ROOT}/astylerc to ~/.astylerc"
  ln -s ${ROOT}/astylerc ~/.astylerc
  success "Install astylerc completed."
}

function install_zsh(){
  step "Installing zsh..."
  if ( is_dir_exists zsh/oh-my-zsh ); then
    info "update oh-my-zsh..."
    cd zsh/oh-my-zsh
    git pull origin master
    go_root
  else
    info "init and update oh-my-zsh..."
    git clone https://github.com/robbyrussell/oh-my-zsh.git zsh/oh-my-zsh
  fi;

  info "Installing zsh and oh-my-zsh......"
  rm -rf ~/.oh-my-zsh
  rm -rf ~/.zshrc

  info "Linking ${ROOT}/zsh/oh-my-zsh to ~/.oh-my-zsh"
  ln -s ${ROOT}/zsh/oh-my-zsh ~/.oh-my-zsh

  info "Linking ${ROOT}/zsh/zshrc to ~/.zshrc";
  ln -s ${ROOT}/zsh/zshrc ~/.zshrc

  info "Time to change your default shell to zsh!"
  if [ "${ZSHPATH}" != "" ]; then
    chsh -s ${ZSHPATH}
  else
    err "No Zsh found! Please install zsh first";
    exit 1
  fi;

  success "Install zsh and oh-my-zsh completed."
  /usr/bin/env zsh
  source ~/.zshrc
}

function install_zshcfg(){
  step "Installing zsh configs..."

  rm -rf ~/.zsh.alias
  rm -rf ~/.zsh.paths
  rm -rf ~/.zsh.sources

  info "Linking zsh configs";
  ln -s ${ROOT}/zsh/zsh.alias ~/.zsh.alias
  ln -s ${ROOT}/zsh/zsh.paths ~/.zsh.paths
  ln -s ${ROOT}/zsh/zsh.sources ~/.zsh.sources

  source ~/.zsh.alias
  source ~/.zsh.paths
  source ~/.zsh.sources

  success "Install zsh configs success";
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
      *)
        err "Invalid params ${arg}"
        ;;
    esac;
  done;
fi;
