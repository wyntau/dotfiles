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
  printf '%b\n' "$*$dot_color_none" >&2
}
function prompt(){
  printf '%b' "$dot_color_purple[+] $*$dot_color_none "
}
function step(){
  msg "\n$dot_color_yellow[→] $*"
}
function info(){
  msg "$dot_color_cyan[>] $*"
}
function success(){
  msg "$dot_color_green[✓] $*"
}
function error(){
  msg "$dot_color_red_light[✗] $*"
}
function tip(){
  msg "$dot_color_red_light[!] $*"
}

function is_file_exists(){
  [[ -e "$1" ]] && return 0 || return 1
}
function is_dir_exists(){
  [[ -d "$1" ]] && return 0 || return 1
}
function is_program_exists(){
  if type "$1" &>/dev/null; then
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

function must_python_pipx_exists(){
  if ( ! is_program_exists pip ) && ( ! is_program_exists pip2 ) && ( ! is_program_exists pip3 ); then
    error "You must have installed pip or pip2 or pip3 for installing python packages."
    exit
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
    rm -rf "$2"
    ln -s "$1" "$2"
  fi;
}

function sync_repo(){

  must_program_exists "git"

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
  echo
  echo 'Usage: install.sh <task>[ taskFoo taskBar ...]'
  echo
  echo 'Tasks:'
  printf "$dot_color_green\n"
  echo '    - fonts_source_code_pro'
  echo '    - vim_rc'
  echo '    - vim_plugins'
  echo '    - vim_plugins_fcitx'
  echo '    - vim_plugins_matchtag'
  echo '    - vim_plugins_snippets'
  echo '    - vim_plugins_ycm'
  echo '    - git_config'
  echo '    - git_diff_fancy'
  echo '    - git_dmtool'
  echo '    - git_extras'
  echo '    - git_flow'
  echo '    - git_standup'
  echo '    - astyle_rc'
  echo '    - sublime2'
  echo '    - sublime3'
  echo '    - vscode'
  echo '    - editorconfig'
  echo '    - zsh_rc'
  echo '    - zsh_plugins_fasd'
  echo '    - zsh_plugins_fzf'
  echo '    - zsh_plugins_thefuck'
  echo '    - tmux'
  printf "$dot_color_none\n"
}

function install_fonts_source_code_pro(){

  if ( ! is_mac ) && ( ! is_linux ); then
    error "This support *Linux* and *Mac* only"
    exit
  fi;

  must_program_exists "git"

  step "Installing font Source Code Pro ..."

  sync_repo "https://github.com/adobe-fonts/source-code-pro.git" \
            "$APP_PATH/.cache/source-code-pro" \
            "release"

  local source_code_pro_ttf_dir="$APP_PATH/.cache/source-code-pro/TTF"

  # borrowed from powerline/fonts/install.sh
  local find_command="find \"$source_code_pro_ttf_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

  local fonts_dir

  if ( is_mac ); then
    # MacOS
    fonts_dir="$HOME/Library/Fonts"
  else
    # Linux
    fonts_dir="$HOME/.fonts"
    mkdir -p $fonts_dir
  fi

  # Copy all fonts to user fonts directory
  eval $find_command | xargs -0 -I % cp "%" "$fonts_dir/"

  # Reset font cache on Linux
  if [[ -n `which fc-cache` ]]; then
    fc-cache -f $fonts_dir
  fi

  success "Successfully installed Source Code Pro font."
}

function install_vim_rc(){

  must_program_exists "vim"

  step "Installing vimrc ..."

  lnif "$APP_PATH/vim" \
       "$HOME/.vim"
  lnif "$APP_PATH/vim/vimrc" \
       "$HOME/.vimrc"

  if ( is_program_exists nvim ); then

    # for newer neovim, code from `:help nvim-from-vim'
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    lnif "$APP_PATH/vim" \
         "$XDG_CONFIG_HOME/nvim"

    # for old neovim
    lnif "$APP_PATH/vim" \
         "$HOME/.nvim"
    lnif "$APP_PATH/vim/vimrc" \
         "$HOME/.nvimrc"

    if ( is_linux ); then
      if ( ! is_program_exists 'xclip' ) && ( ! is_program_exists 'xsel' ); then
        tip "Maybe you should install *xclip* or *xsel* for sharing data between vim registers and system clipboard"
      fi;
    fi;
  fi;

  success "Successfully installed vimrc."

  success "You can add your own configs to ~/.vimrc.local, vim will source them automatically"
}

function append_dotvim_group(){
  local group=$1
  local conf="$HOME/.vimrc.plugins.before"

  if ! grep -iE "^[ \t]*let[ \t]+g:dotvim_groups[ \t]*=[ \t]*\[.+]" "$conf" &>/dev/null ; then
    printf "\nlet g:dotvim_groups = ['$group']" >> "$conf"
  elif ! grep -iE "'$group'" "$conf" &>/dev/null; then
    sed -e "s/]/, '$group']/" "$conf" | tee "$conf" &>/dev/null
    if grep -iE "\[[ \t]*," "$conf" &>/dev/null; then
      sed -e "s/\[[ \t]*,[ \t]*/[/" "$conf" | tee "$conf" &>/dev/null
    fi;
  fi;
}

function install_vim_plugins(){

  if ( ! is_file_exists "$HOME/.vimrc" ); then
    error "You should complete vim_rc task first"
    exit
  fi;

  step "Initializing vim-plug"

  sync_repo "https://github.com/junegunn/vim-plug.git" \
            "$APP_PATH/vim/autoload"

  lnif "$APP_PATH/vim/vimrc.plugins" \
       "$HOME/.vimrc.plugins"

  vim +PlugInstall +qall

  better_program_exists_one "ag"

  success "You can add your own plugins to ~/.vimrc.plugins.local , vim will source them automatically"

  install_fonts_source_code_pro
  tip "In order to use powerline symbols with airline in vim, please set your terminal to use the font *Source Code Pro*"
}

function must_vimrc_plugins_exists(){
  if ( ! is_file_exists "$HOME/.vimrc.plugins" ); then
    error "You should complete vim_plugins task first"
    exit
  fi;
}

function install_vim_plugins_fcitx(){

  must_vimrc_plugins_exists

  step "installing fcitx support plugin for vim ..."

  if ( is_mac ); then
    if [ "$FCITX_IM" = "" ]; then
      error "You must set FCITX_IM to use fcitx-vim-osx plugin"
      exit
    fi;
    sync_repo "https://github.com/CodeFalling/fcitx-remote-for-osx.git" \
              "$APP_PATH/vim/.cache/fcitx-remote-for-osx" \
              "binary"
    lnif "$APP_PATH/vim/.cache/fcitx-remote-for-osx/fcitx-remote-$FCITX_IM" \
         "/usr/local/bin/fcitx-remote"
  fi;

  append_dotvim_group "fcitx"

  vim +PlugInstall +qall

  success "Successfully installed fcitx support plugin."
}

function ensure_neovim_python_support(){

  if ( ! is_program_exists nvim ); then
    return
  fi;

  if [[ `uname -a` =~ "gentoo" ]] && ( is_file_exists /etc/gentoo-release ); then
      # in gentoo, recommend enable python USE flag to automatically install pynvim
      tip "You are using Gentoo Linux."
      tip "You should enable *python* USE flag for neovim, and reinstall neovim."
      tip "Then dev-python/neovim-python-client will be installed automatically."
      tip "Also you can run '[sudo] emerge -a dev-python/neovim-python-client' manually."
      return
  fi;

  must_python_pipx_exists

  if ( is_program_exists pip2 ); then
    info "Installing python2 neovim package ..."
    pip2 install --user --upgrade neovim
  elif ( is_program_exists pip ); then
    info "Installing python2 neovim package ..."
    pip install --user --upgrade neovim
  fi;

  if ( is_program_exists pip3 ); then
    info "Installing python3 neovim package ..."
    pip3 install --user --upgrade neovim
  fi;

  success "Successfully installed neovim python client."
}

function install_vim_plugins_matchtag(){

  must_vimrc_plugins_exists

  must_program_exists "python"

  step "Installing vim MatchTagAlways plugin ..."

  # check whether have neovim. if have, make sure neovim have python feature support
  ensure_neovim_python_support

  append_dotvim_group "matchtag"

  vim +PlugInstall +qall

  success "Successfully installed MatchTagAlways plugins."
}

function install_vim_plugins_snippets(){

  must_vimrc_plugins_exists

  must_program_exists "python"

  step "Installing vim snippets plugin ..."

  # check whether have neovim. if have, make sure neovim have python feature support
  ensure_neovim_python_support

  append_dotvim_group "snippets"

  vim +PlugInstall +qall

  success "Successfully installed vim-snippets plugins."
}

function install_vim_plugins_ycm(){

  must_vimrc_plugins_exists

  must_program_exists "python"

  step "Installing vim YouCompleteMe plugin ..."

  # check whether have neovim. if have, make sure neovim have python feature support
  ensure_neovim_python_support

  # fetch or update YouCompleteMe
  sync_repo "https://github.com/Valloric/YouCompleteMe.git" \
            "$APP_PATH/vim/plugins/YouCompleteMe"

  # Force recompile YouCompleteMe libs
  # or YouCompleteMe libs not exists
  # compile libs for YouCompleteMe
  local ycmd_path="$APP_PATH/vim/plugins/YouCompleteMe/third_party/ycmd"
  if [[ "$YCM_COMPILE_FORCE" = "true" ]] || ( ! is_file_exists "$ycmd_path/ycm_core.so" ) || ( ! is_file_exists "$ycmd_path/ycm_client_support.so" ); then
    info "Compiling YouCompleteMe libs ..."
    "$APP_PATH/vim/plugins/YouCompleteMe/install.py" $YCM_COMPLETER_FLAG
  fi;

  append_dotvim_group "youcompleteme"

  success "Successfully installed YouCompleteMe plugin."
}

function install_sublime2(){

  local sublime_path

  if ( is_linux ); then
    sublime_path="$HOME/.config/sublime-text-2"
  elif ( is_mac ); then
    sublime_path="$HOME/Library/Application Support/Sublime Text 2"
  else
    error "Can't detect your platform. This support *Linux* and *Mac* only"
    exit
  fi;

  step "Installing sublime2 configs ..."

  sync_repo "https://github.com/jonschlinkert/sublime-monokai-extended.git" \
            "$APP_PATH/sublime2/.cache/monokai-extended"
  lnif "$APP_PATH/sublime2/.cache/monokai-extended" \
       "$sublime_path/Packages/User/monokai-extended"

  sync_repo "https://github.com/jonschlinkert/sublime-markdown-extended.git" \
            "$APP_PATH/sublime2/.cache/markdown-extended"
  lnif "$APP_PATH/sublime2/.cache/markdown-extended" \
       "$sublime_path/Packages/User/markdown-extended"

  lnif "$APP_PATH/sublime2/Preferences.sublime-settings" \
       "$sublime_path/Packages/User/Preferences.sublime-settings"

  success "Successfully installed sublime2 Preference and monokai-extended theme"

  install_fonts_source_code_pro

  tip "You can change font_size and font_face in your sublime Preference"
}

function install_sublime3(){

  local sublime_path

  if ( is_linux ); then
    sublime_path="$HOME/.config/sublime-text-3"
  elif ( is_mac ); then
    sublime_path="$HOME/Library/Application Support/Sublime Text 3"
  else
    error "Can't detect your platform. This support *Linux* and *Mac* only"
    exit
  fi;

  step "Installing sublime3 configs ..."

  sync_repo "https://github.com/jonschlinkert/sublime-monokai-extended.git" \
            "$APP_PATH/sublime3/.cache/monokai-extended"
  lnif "$APP_PATH/sublime3/.cache/monokai-extended" \
       "$sublime_path/Packages/User/monokai-extended"

  sync_repo "https://github.com/jonschlinkert/sublime-markdown-extended.git" \
            "$APP_PATH/sublime3/.cache/markdown-extended"
  lnif "$APP_PATH/sublime3/.cache/markdown-extended" \
       "$sublime_path/Packages/User/markdown-extended"

  lnif "$APP_PATH/sublime3/Preferences.sublime-settings" \
       "$sublime_path/Packages/User/Preferences.sublime-settings"

  success "Successfully installed sublime3 Preference and monokai-extended theme"

  install_fonts_source_code_pro

  tip "You can change font_size and font_face in your sublime Preference"
}

function install_vscode(){

  local vscode_path
  local vscode_keybindings

  if( is_linux ); then
    vscode_path="$HOME/.config/Code"
    vscode_keybindings="$APP_PATH/vscode/keybindings.linux.json"
  elif( is_mac ); then
    vscode_path="$HOME/Library/Application Support/Code"
    vscode_keybindings="$APP_PATH/vscode/keybindings.osx.json"
  else
    error "Can't detect your platform. This support *Linux* and *Mac* only"
    exit
  fi;

  step "Installing vscode configs ..."

  mkdir -p "$vscode_path/User"

  lnif "$APP_PATH/vscode/settings.json" \
       "$vscode_path/User/settings.json"

  lnif "$vscode_keybindings" \
       "$vscode_path/User/keybindings.json"

  success "Successfully installed vscode configs."

  install_fonts_source_code_pro
}

function install_editorconfig(){

  step "Installing editorconfig ..."

  lnif "$APP_PATH/editorconfig/editorconfig" \
       "$HOME/.editorconfig"

  tip "Maybe you should install editorconfig plugin for vim or sublime"
  success "Successfully installed editorconfig."
}

function install_git_config(){

  must_program_exists "git"

  step "Installing gitconfig ..."

  lnif "$APP_PATH/git/gitconfig" \
       "$HOME/.gitconfig"

  info "Now config your name and email for git."

  local user_now=`whoami`

  prompt "What's your git username? ($user_now) "

  local user_name
  read user_name
  if [ "$user_name" = "" ]; then
    user_name=$user_now
  fi;
  git config --global user.name $user_name

  prompt "What's your git email? ($user_name@example.com) "

  local user_email
  read user_email
  if [ "$user_email" = "" ]; then
    user_email=$user_now@example.com
  fi;
  git config --global user.email $user_email

  if ( is_mac ); then
    git config --global credential.helper osxkeychain
  fi;

  success "Successfully installed gitconfig."
}

function install_git_diff_fancy(){

  must_program_exists "git"

  step "Installing git diff-so-fancy ..."

  sync_repo "https://github.com/so-fancy/diff-so-fancy.git" \
            "$APP_PATH/git/.cache/diff-so-fancy"
  cd "$APP_PATH/git/.cache/diff-so-fancy"

  lnif "$APP_PATH/git/.cache/diff-so-fancy/diff-so-fancy" \
       "/usr/local/bin/diff-so-fancy"

  # use diff-so-fancy globally
  # git config --global pager.diff "diff-so-fancy | less --tabs=4 -RFX"
  # git config --global pager.show "diff-so-fancy | less --tabs=4 -RFX"

  # override default 'git df' and 'git dfc'
  git config --global alias.df '!f() { [ "$GIT_PREFIX" != "" ] && cd "$GIT_PREFIX"; git diff --color $@ | diff-so-fancy | less --tabs=4 -RFX; }; f'
  git config --global alias.dfc '!f() { [ "$GIT_PREFIX" != "" ] && cd "$GIT_PREFIX"; git diff --cached --color $@ | diff-so-fancy | less --tabs=4 -RFX; }; f'

  # add 'dfr' and 'dfcr' for origin 'df' and 'dfc'
  git config --global alias.dfr 'diff'
  git config --global alias.dfcr 'diff --cached'

  git config --global color.diff-highlight.oldNormal "red bold"
  git config --global color.diff-highlight.oldHighlight "red bold 52"
  git config --global color.diff-highlight.newNormal "green bold"
  git config --global color.diff-highlight.newHighlight "green bold 22"

  success "Successfully installed git diff-so-fancy."
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
            "$APP_PATH/git/.cache/git-extras"
  cd "$APP_PATH/git/.cache/git-extras"
  sudo make install

  success "Successfully installed git-extras."
}

function install_git_flow(){

  must_program_exists "git"

  step "Installing git-flow-avh ..."
  sync_repo "https://github.com/petervanderdoes/gitflow-avh.git" \
            "$APP_PATH/git/.cache/git-flow-avh"
  cd "$APP_PATH/git/.cache/git-flow-avh"
  sudo make install

  step "Installing git-flow-completion ..."
  sync_repo "https://github.com/petervanderdoes/git-flow-completion.git" \
            "$APP_PATH/zsh/oh-my-zsh/custom/plugins/git-flow-completion"

  success "Successfully installed git-flow-avh and git-flow-completion."
}

function install_git_standup(){

  must_program_exists "git"

  step "Installing git-standup ..."

  sync_repo "https://github.com/kamranahmedse/git-standup.git" \
            "$APP_PATH/git/.cache/git-standup"
  cd "$APP_PATH/git/.cache/git-standup"
  sudo make install

  success "Successfully installed git-standup."
}

function install_astyle_rc(){

  must_program_exists "astyle"

  step "Installing astylerc ..."

  lnif "$APP_PATH/astyle/astylerc" \
       "$HOME/.astylerc"

  success "Successfully installed astylerc."
}

function install_zsh_rc(){

  must_program_exists "zsh"

  step "Installing zshrc ..."

  sync_repo "https://github.com/robbyrussell/oh-my-zsh.git" \
            "$APP_PATH/zsh/oh-my-zsh"

  # add zsh plugin zsh-syntax-highlighting support
  sync_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
            "$APP_PATH/zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

  # add zsh plugin zsh-autosuggestions support
  sync_repo "https://github.com/tarruda/zsh-autosuggestions.git" \
            "$APP_PATH/zsh/oh-my-zsh/custom/plugins/zsh-autosuggestions"

  lnif "$APP_PATH/zsh/oh-my-zsh" \
       "$HOME/.oh-my-zsh"
  lnif "$APP_PATH/zsh/zshrc" \
       "$HOME/.zshrc"

  info "Time to change your default shell to zsh!"
  chsh -s `which zsh`

  success "Successfully installed zsh and oh-my-zsh."
  tip "You can add your own configs to ~/.zshrc.local , zsh will source them automatically"

  cd $CUR_PATH
  success "Please open a new zsh terminal to make configs go into effect."
}

function install_zsh_cfg(){

  must_program_exists "zsh"

  step "Installing zsh configs ..."

  lnif "$APP_PATH/zsh/zshrc.alias" \
       "$HOME/.zshrc.alias"
  lnif "$APP_PATH/zsh/zshrc.paths" \
       "$HOME/.zshrc.paths"
  lnif "$APP_PATH/zsh/zshrc.sources" \
       "$HOME/.zshrc.sources"

  success "Successfully installed zsh configs"
  success "Please open a new zsh terminal to make configs go into effect."
}

function install_zsh_plugins_fasd(){
  step "Installing fasd plugin for oh-my-zsh ..."

  # add zsh plugin fasd support
  sync_repo "https://github.com/clvv/fasd.git" \
            "$APP_PATH/zsh/.cache/fasd"
  cd "$APP_PATH/zsh/.cache/fasd"
  sudo make install

  success "Successfully installed fasd plugin."
  success "Please open a new zsh terminal to make configs go into effect."
}

function install_zsh_plugins_fzf(){
  step "Installing fzf plugin for oh-my-zsh ..."

  # add zsh plugin fzf support
  sync_repo "https://github.com/junegunn/fzf.git" \
            "$APP_PATH/zsh/oh-my-zsh/custom/plugins/fzf"
  "$APP_PATH/zsh/oh-my-zsh/custom/plugins/fzf/install" --bin
  sync_repo "https://github.com/Treri/fzf-zsh.git" \
            "$APP_PATH/zsh/oh-my-zsh/custom/plugins/fzf-zsh"

  success "Successfully installed fzf plugin."
  success "Please open a new zsh terminal to make configs go into effect."
}

function install_zsh_plugins_thefuck(){
  step "Installing thefuck plugin for oh-my-zsh ..."

  # add zsh plugin thefuck support
  must_python_pipx_exists

  if ( is_program_exists pip3 ); then
    pip3 install --user --upgrade thefuck
  elif ( is_program_exists pip2 ); then
    pip2 install --user --upgrade thefuck
  elif ( is_program_exists pip ); then
    pip install --user --upgrade thefuck
  fi;

  mkdir -p "$APP_PATH/zsh/oh-my-zsh/custom/plugins/thefuck"
  echo 'eval "$(thefuck --alias)"' > "$APP_PATH/zsh/oh-my-zsh/custom/plugins/thefuck/thefuck.plugin.zsh"

  success "Successfully installed thefuck plugin."
  success "Please open a new zsh terminal to make configs go into effect."
}

function install_tmux(){

  must_program_exists "tmux"

  step "Installing tmux configs ..."

  sync_repo "https://github.com/tmux-plugins/tpm" \
            "$APP_PATH/tmux/plugins/tpm"

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

  lnif "$APP_PATH/tmux" \
       "$HOME/.tmux"
  lnif "$APP_PATH/tmux/tmux.conf" \
       "$HOME/.tmux.conf"

  success "Please run tmux and use prefix-I to install tmux plugins or reload your tmux.conf"
}

function install_homebrew(){

  if ( is_program_exists "brew" ); then
    success "You have already installed homebrew"
    exit
  fi;

  must_program_exists "ruby" \
                      "curl"

  if ( is_mac ); then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif ( is_linux ); then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi;

  success "Successfully installed homebrew"
}

if [ $# = 0 ]; then
  usage
else
  for arg in $@; do
    case $arg in
      vim_rc)
        install_vim_rc
        ;;
      vim_plugins)
        install_vim_plugins
        ;;
      vim_plugins_fcitx)
        install_vim_plugins_fcitx
        ;;
      vim_plugins_matchtag)
        install_vim_plugins_matchtag
        ;;
      vim_plugins_snippets)
        install_vim_plugins_snippets
        ;;
      vim_plugins_ycm)
        install_vim_plugins_ycm
        ;;
      git_config)
        install_git_config
        ;;
      git_diff_fancy)
        install_git_diff_fancy
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
      git_standup)
        install_git_standup
        ;;
      fonts_source_code_pro)
        install_fonts_source_code_pro
        ;;
      astyle_rc)
        install_astyle_rc
        ;;
      sublime2)
        install_sublime2
        ;;
      sublime3)
        install_sublime3
        ;;
      vscode)
        install_vscode
        ;;
      editorconfig)
        install_editorconfig
        ;;
      zsh_rc)
        install_zsh_rc
        ;;
      zsh_plugins_fasd)
        install_zsh_plugins_fasd
        ;;
      zsh_plugins_fzf)
        install_zsh_plugins_fzf
        ;;
      zsh_plugins_thefuck)
        install_zsh_plugins_thefuck
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
        error "Invalid params $arg"
        usage
        ;;
    esac;
  done;
fi;
