#!/usr/bin/env bash

########## Params setup

## where user excute the install.sh
CUR_PATH=`pwd`
## get the real path of install.sh
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -L "$SOURCE" ]; do
  APP_PATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path
  # where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$APP_PATH/$SOURCE"
done
APP_PATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

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

########## Basics setup
function msg(){
  printf '%b\n' "$*${dot_color_none}" >&2
}
function prompt(){
  printf '%b' "${dot_color_purple}[+] $*${dot_color_none} "
}
function step(){
  msg "\n${dot_color_yellow}[→] $*"
}
function info(){
  msg "${dot_color_cyan}[>] $*"
}
function success(){
  msg "${dot_color_green}[✓] $*\n"
}
function error(){
  msg "${dot_color_red_light}[✗] $*"
}
function tip(){
  msg "${dot_color_red_light}[!] $*"
}

function is_file_exists(){
  [[ -e "$1" ]] && return 0 || return 1
}
function is_dir_exists(){
  [[ -d "$1" ]] && return 0 || return 1
}
function is_program_exists(){
  if hash "$1" 2>/dev/null; then
    return 0
  else
    return 1
  fi;
}
function must_file_exists(){
  for file in $@; do
    if ( ! is_file_exists $file ); then
      error "You must have file *$file*"
      exit
    fi;
  done;
}
function better_program_exists_one(){
  local exists="no"
  for program in $@; do
    if ( is_program_exists "$program" ); then
      exists="yes"
      break
    fi;
  done;
  if [[ "$exists" = "no" ]]; then
    tip "Maybe you can take full use of this by installing one of ($*)~"
  fi;
}
function must_program_exists(){
  for program in $@; do
    if ( ! is_program_exists "$program" ); then
      error "You must have *$program* installed!"
      exit
    fi;
  done;
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
    rm -rf "$2"
    ln -s "$1" "$2"
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

########## Steps setup

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
  echo '    - all          ==> do all things below'
  echo '    - vim_rc'
  echo '    - vim_ycm      ==> vim plugin YouCompleteMe'
  echo '    - git_config'
  echo '    - git_dmtool   ==> config difftool and mergetool to Kaleidoscope'
  echo '    - git_extras   ==> git-extras extensions'
  echo '    - git_flow     ==> git-flow extensions'
  echo '    - astylerc'
  echo '    - sublime'
  echo '    - zsh_rc'
  echo '    - tmux'
  printf "${dot_color_none}\n"
}

function install_vim_rc(){

  must_program_exists "git" \
                      "vim"

  step "Installing vimrc ..."

  sync_repo "https://github.com/gmarik/Vundle.vim.git" \
            "${APP_PATH}/vim/bundle/Vundle.vim"

  sync_repo "https://github.com/powerline/fonts.git" \
            "${APP_PATH}/vim/powerline-fonts"

  info "Installing powerline-fonts ..."
  "${APP_PATH}/vim/powerline-fonts/install.sh"
  tip "When install completed, please set your terminal to use powerline fonts for *Non-ASCII font*"

  lnif "${APP_PATH}/vim" \
       "$HOME/.vim"
  lnif "${APP_PATH}/vim/vimrc" \
       "$HOME/.vimrc"
  lnif "${APP_PATH}/vim/vimrc.bundles" \
       "$HOME/.vimrc.bundles"

  if ( is_program_exists nvim ); then

    lnif "${APP_PATH}/vim/vimrc" \
         "$HOME/.nvimrc"

    if ( is_linux ); then
      if ( ! is_program_exists 'xclip' ) && ( ! is_program_exists 'xsel' ); then
        tip "Maybe you should install xlip or xsel for sharing data between vim registers and system clipboard"
      fi;
    fi;
  fi;

  better_program_exists_one "ag"

  info "Installing vim bundles ..."
  vim +PluginInstall +qall

  success "Successfully installed vimrc and bundles."

  success "You can add your own configs to ~/.vimrc.local, and your own plugins to ~/.vimrc.bundles.local , vim will source them automatically"
}

function install_vim_ycm(){

  must_program_exists "git" \
                      "vim" \
                      "python"

  step "Installing vim YouCompleteMe plugin ..."

  # install pynvim module for neovim
  if ( is_program_exists nvim ) && ( ! is_program_exists pynvim ); then
    info "Installing pynvim for YouCompleteMe plugin in neovim ..."
    if ( `uname -a` =~ "gentoo" ) && ( is_file_exists /etc/gentoo-release ); then
      # in gentoo, recommend enable python USE flag to automatically install pynvim
      tip "You are using Gentoo Linux."
      tip "You should enable 'python' USE flag for neovim, and reinstall neovim."
      tip "Then pynvim(dev-python/neovim-python-client) will be installed automatically."
      tip "Also you can run '[sudo] emerge -a dev-python/neovim-python-client' manually."
    else
      # install python package manager pip
      if ( ! is_program_exists pip ); then

        must_program_exists "wget"

        info "Installing pip for you..."

        mkdir -p "${APP_PATH}/.tmp"
        wget https://bootstrap.pypa.io/get-pip.py -O "${APP_PATH}/.tmp/get-pip.py"
        chmod +x "${APP_PATH}/.tmp/get-pip.py"
        sudo "${APP_PATH}/.tmp/get-pip.py"
        rm -rf "${APP_PATH}/.tmp"

        success "Successfully installed pip."
      fi;
      sudo pip install neovim
      success "Successfully installed pynvim."
    fi;
  fi;

  # fetch or update YouCompleteMe
  sync_repo "https://github.com/Valloric/YouCompleteMe.git" \
            "${APP_PATH}/vim/bundle/YouCompleteMe"

  # compile libs for YouCompleteMe
  if ( ! is_file_exists "${APP_PATH}/vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ) || ( ! is_file_exists "${APP_PATH}/vim/bundle/YouCompleteMe/third_party/ycmd/ycm_client_support.so" ); then
    info "Fetching and compiling YouCompleteMe libs ..."
    "${APP_PATH}/vim/bundle/YouCompleteMe/install.sh" --clang-completer
  fi;

  lnif "${APP_PATH}/vim/vimrc.bundles.ycm" \
       "$HOME/.vimrc.bundles.ycm"

  success "Successfully installed YouCompleteMe plugin."
}

function install_sublime(){

  must_program_exists "git"

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

  lnif "${APP_PATH}/sublime/monokai-custom" \
       "${SUBLIMEPATH}/Packages/User/monokai-custom"
  lnif "${APP_PATH}/sublime/Preferences.sublime-settings" \
       "${SUBLIMEPATH}/Packages/User/Preferences.sublime-settings"

  success "Successfully installed sublime Preference and Monokai-custom theme"
  tip "You may want to change font_face in your sublime Preference"
}

function install_git_config(){

  must_program_exists "git"

  step "Installing gitconfig ..."

  lnif "${APP_PATH}/git/gitconfig" \
       "$HOME/.gitconfig"

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

function install_git_dmtool(){

  if ( ! is_mac ); then
    error "Only MAC is supported"
    exit
  fi;

  must_program_exists "git" \
                      "ksdiff"

  must_file_exists "/Applications/Kaleidoscope.app/Contents/MacOS/Kaleidoscope"

  step "Config git's difftool and mergetool to Kaleidoscope ..."

  info "Config git's difftool to Kaleidoscope"
  git config --global diff.tool Kaleidoscope
  git config --global difftool.Kaleidoscope.cmd 'ksdiff --partial-changeset --relative-path "$MERGED" -- "$LOCAL" "$REMOTE"'
  git config --global difftool.prompt false

  info "Config git's mergetool to Kaleidoscope"
  git config --global merge.tool Kaleidoscope
  git config --global mergetool.Kaleidoscope.cmd 'ksdiff --merge --output "$MERGED" --base "$BASE" -- "$LOCAL" --snapshot "$REMOTE" --snapshot'
  git config --global mergetool.Kaleidoscope.trustExitCode true
  git config --global mergetool.prompt false

  success "Successfully config git's difftool and mergetool"
}

function install_git_extras(){

  must_program_exists "git"

  step "Installing git-extras ..."

  sync_repo "https://github.com/tj/git-extras.git" \
            "${APP_PATH}/git/plugins/git-extras"

  cd "${APP_PATH}/git/plugins/git-extras"
  sudo make install

  success "Successfully installed git-extras."
}

function install_git_flow(){

  must_program_exists "git"

  step "Installing git-flow ..."

  sync_repo "https://github.com/nvie/gitflow.git" \
            "${APP_PATH}/git/plugins/git-flow"

  cd "${APP_PATH}/git/plugins/git-flow"
  sudo make install

  success "Successfully installed git-flow."
}

function install_astylerc(){

  must_program_exists "astyle"

  step "Installing astylerc ..."

  lnif "${APP_PATH}/astylerc" \
       "$HOME/.astylerc"

  success "Successfully installed astylerc."
}

function install_zsh_rc(){

  must_program_exists "git" \
                      "zsh"

  step "Installing zshrc ..."

  sync_repo "https://github.com/robbyrussell/oh-my-zsh.git" \
            "${APP_PATH}/zsh/oh-my-zsh"

  sync_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
            "${APP_PATH}/zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

  lnif "${APP_PATH}/zsh/oh-my-zsh" \
       "$HOME/.oh-my-zsh"
  lnif "${APP_PATH}/zsh/zshrc" \
       "$HOME/.zshrc"

  info "Time to change your default shell to zsh!"
  chsh -s `which zsh`

  success "Successfully installed zsh and oh-my-zsh."
  cd ${CUR_PATH}
  /usr/bin/env zsh
  source $HOME/.zshrc
}

function install_zsh_cfg(){

  must_program_exists "zsh"

  step "Installing zsh configs ..."

  lnif "${APP_PATH}/zsh/zshrc.alias" \
       "$HOME/.zshrc.alias"
  lnif "${APP_PATH}/zsh/zshrc.paths" \
       "$HOME/.zshrc.paths"
  lnif "${APP_PATH}/zsh/zshrc.sources" \
       "$HOME/.zshrc.sources"

  source "$HOME/.zshrc.alias"
  source "$HOME/.zshrc.paths"
  source "$HOME/.zshrc.sources"

  success "Successfully installed zsh configs"
}

function install_tmux(){

  must_program_exists "git" \
                      "tmux"

  step "Installing tmux configs ..."

  sync_repo "https://github.com/tmux-plugins/tpm" \
            "${APP_PATH}/tmux/plugins/tpm"

  # tmux中的vim无法使用系统的粘贴板, 安装reattach-to-user-namespace修复
  if ( is_mac ); then
    if( ! is_program_exists reattach-to-user-namespace ); then
      if ( is_program_exists brew ); then
        brew install reattach-to-user-namespace
      else
        tip "Maybe you should install reattach-to-user-namespace for vim in tmux"
      fi;
    fi;
  fi;

  lnif "${APP_PATH}/tmux" \
       "$HOME/.tmux"
  lnif "${APP_PATH}/tmux/tmux.conf" \
       "$HOME/.tmux.conf"

  success "Please run tmux and use prefix-I to install tmux plugins or reload your tmux.conf"
}

function install_homebrew(){

  if( ! is_mac ); then
    error "Only *MAC* is supported"
    exit
  fi;

  if ( is_program_exists "brew" ); then
    success "You have already installed homebrew"
    exit
  fi;

  must_program_exists "ruby" \
                      "curl"

  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  success "Successfully installed homebrew"
}

if [ $# = 0 ]; then
  usage
else
  for arg in $@; do
    case $arg in
      all)
        install_vim_rc
        install_vim_ycm
        install_git_config
        install_git_dmtool
        install_git_extras
        install_git_flow
        install_astylerc
        install_sublime
        install_tmux
        install_zsh_rc
        ;;
      vim_rc)
        install_vim_rc
        ;;
      vim_ycm)
        install_vim_ycm
        ;;
      git_config)
        install_git_config
        ;;
      git_dmtool)
        install_git_dmtool
        ;;
      git_extras)
        install_git_extras
        ;;
      git_flow)
        install_git_flow
        ;;
      astylerc)
        install_astylerc
        ;;
      sublime)
        install_sublime
        ;;
      zsh_rc)
        install_zsh_rc
        ;;
      zsh_cfg)
        install_zsh_cfg
        ;;
      tmux)
        install_tmux
        ;;
      homebrew)
        install_homebrew
        ;;
      *)
        echo
        error "Invalid params ${arg}"
        usage
        ;;
    esac;
  done;
fi;
