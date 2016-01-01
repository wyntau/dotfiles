## What are in the repo
    dotfile
    ├── astyle
    │   └── astylerc
    ├── editorconfig
    ├── git
    │   └── gitconfig
    ├── sublime2
    │   ├── Preferences.sublime-settings
    │   └── README.md
    ├── sublime3
    │   ├── Preferences.sublime-settings
    │   └── README.md
    ├── terminfo
    │   ├── README.md
    │   ├── screen-256color-italic.terminfo
    │   └── xterm-256color-italic.terminfo
    ├── tmux
    │   └── tmux.conf
    ├── vim
    │   ├── init.vim -> vimrc
    │   ├── vimrc
    │   └── vimrc.plugins
    └── zsh
        └── zshrc

## Tasks
All vailable tasks:

- [fonts_source_code_pro](#task-fonts_source_code_pro)
- [vim_rc](#task-vim_rc)
- [vim_plugins](#task-vim_plugins)
- [vim_plugins_fcitx](#task-vim_plugins_fcitx)
- [vim_plugins_matchtag](#task-vim_plugins_matchtag)
- [vim_plugins_snippets](#task-vim_plugins_snippets)
- [vim_plugins_ycm](#task-vim_plugins_ycm)
- [git_config](#task-git_config)
- [git_dmtool](#task-git_dmtool)
- [git_extras](#task-git_extras)
- [git_flow](#task-git_flow)
- [astyle_rc](#task-astyle_rc)
- [sublime2](#task-sublime2)
- [sublime3](#task-sublime3)
- [editorconfig](#task-editorconfig)
- [zsh_rc](#task-zsh_rc)
- [zsh_plugins_fasd](#task-zsh_plugins_fasd)
- [zsh_plugins_fzf](#task-zsh_plugins_fzf)
- [zsh_plugins_thefuck](#task-zsh_plugins_thefuck)
- [tmux](#task-tmux)

You can do a specific task by run

    ./install.sh <taskname1>[ <taskname2> <tasknameN> ...]

- ### Task `fonts_source_code_pro`
    Requirements: `git`

    This task will install
    [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) font for you.

    The new version font is compatible with powerline fonts which have some
    useful symbols used in some vim plugins and shell plugins, and it will
    update frequently. So use it to replace
    [Powerline fonts](https://github.com/powerline/fonts).

    This font will be installed automatically when do task
    [vim_plugins](#task-vim_plugins), [sublime2](#task-sublime2) and
    [sublime3](#task-sublime3).

- ### Task `vim_rc`
    Requirements: `git`, `vim`

    This task will not install any plugin, if you want to use some plugins, do
    __[task vim_plugins](#task-vim_plugins)__.

    You can override the system vim with the new one installed by `homebrew`.
    (OS X only. This is optional, but recommended, because system vim can't use
    system clipbord via register `+`)

        brew install macvim --with-override-system-vim

    And then add the new vim __PATH__ into your `$PATH`.

    Additionally, if you have installed `neovim`, this task will link `vim` to
    `~/.nvim`, `vim/vimrc` to `~/.nvimrc`.

- ### Task `vim_plugins`
    Requirement: `git`, `vim`, [task vim_rc](#task-vim_rc)

    Setup vim-plug, and load other plugins.

    We have some plugins_group below.

    - themes
    - interface
    - explorer
    - motion
    - writing
    - git
    - tmux
    - html
    - css
    - js
    - php
    - markdown
    - nginx
    - nfo

    In above plugins_groups, only `themes` and `interface` will be loaded default.
    After this task complete, you can add your own plugins_group or load your own
    plugins in `~/.vimrc.plugin.local` like below.

    ```viml
    " load some plugins groups
    let g:plugins_groups = ['explorer', 'git', 'js']

    " load your own plugins
    " Plug 'name/repo'
    ```

    If you want to include most of them but except some one, you can set
    `g:plugins_groups` like below.

    ```viml
    " include groups except nfo and git
    let g:plugins_groups = ['common', '-nfo', '-git']
    ```

    ##### Included plugin(s)
    ```viml
    " group 'themes'
    Plug 'tomasr/molokai'
    Plug 'altercation/vim-colors-solarized'
    Plug 'morhetz/gruvbox'
    Plug 'junegunn/seoul256.vim'
    Plug 'zeis/vim-kolor'

    " group 'interface'
    Plug 'bling/vim-airline'
    Plug 'Yggdroot/indentLine'

    " group 'explorer'
    Plug 'schickling/vim-bufonly'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tacahiroy/ctrlp-funky'
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'dyng/ctrlsf.vim'
    Plug 't9md/vim-choosewin'

    " group 'motion'
    Plug 'justinmk/vim-sneak'
    Plug 'easymotion/vim-easymotion'
    Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-easymotion.vim'
    Plug 'terryma/vim-expand-region'
    Plug 't9md/vim-textmanip'

    " group 'writing'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'Raimondi/delimitMate'
    Plug 'junegunn/vim-easy-align'
    Plug 'wellle/targets.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'scrooloose/nerdcommenter'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'osyo-manga/vim-over'

    " group 'git'
    Plug 'airblade/vim-gitgutter'

    " group 'tmux'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'christoomey/vim-tmux-navigator'

    " group 'html'
    Plug 'tmhedberg/matchit'
    Plug 'mattn/emmet-vim'

    " group 'css'
    Plug 'groenewege/vim-less'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'Marslo/vim-coloresque'

    " group 'js'
    Plug 'leafgarland/typescript-vim'
    Plug 'kchmck/vim-coffee-script'
    Plug 'pangloss/vim-javascript'
    Plug 'mxw/vim-jsx'
    Plug 'othree/yajs.vim'
    Plug 'heavenshell/vim-jsdoc'

    " group 'php'
    Plug 'SirVer/ultisnips'
    Plug 'tobyS/vmustache'
    Plug 'tobyS/pdv'

    " group 'markdown'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    Plug 'amiorin/vim-fenced-code-blocks'

    " group 'nginx'
    Plug 'evanmiller/nginx-vim-syntax'

    " group 'nfo'
    Plug 'smilekzs/vim-nfo'
    ```

- ### Task `vim_plugins_fcitx`
    Requirement: `git`, `vim`, [task vim_plugins](#task-vim_plugins)

    Install fcitx support plugin for vim. This plugin help you to switch input
    method(eg. English and Chinese keyboard) automatically when you switch vim
    `Insert` and `Normal` mode.

    ##### Included plugin(s)
    ```viml
    " group 'fcitx'
    Plug 'CodeFalling/fcitx-vim-osx'
    ```

- ### Task `vim_plugins_matchtag`
    Requirement: `git`, `vim`, `curl`, `python`,
    [task vim_plugins](#task-vim_plugins)

    Install html matchtag plugin for vim. Here i use python version matchtag.
    If you don't want to include python modules, you can also use non-python
    version 'gregsexton/MatchTag'

    ##### Included plugin(s)
    ```viml
    " group 'matchtag'
    Plug 'valloric/MatchTagAlways'
    ```

- ### Task `vim_plugins_snippets`
    Requirement: `git`, `vim`, `curl`, `python`,
    [task vim_plugins](#task-vim_plugins)

    Install vim-snippets plugin for vim.

    ##### Included plugin(s)
    ```viml
    " group 'snippets'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    ```

- ### Task `vim_plugins_ycm`
    Requirement: `git`, `vim`, `curl`, `python`,
    [task vim_plugins](#task-vim_plugins)

    Install YouCompleteMe plugin for vim.

    If YouCompleteMe lib files not exist, or you force YouCompleteMe to
    recompile with `export YCM_COMPILE_FORCE=true`, YouCompleteMe lib files
    will be compiled automatically.

    Also you can set `YCM_COMPLETER_FLAG` with different language support.

    e.g.
    ```sh
    YCM_COMPLETER_FLAG="--tern-completer" ./install.sh vim_plugins_ycm
    ```

    If you want to enable `--tern-completer` support, You may want to have `node`
    and `npm` installed and `.tern-project` config file in you project or
    `$HOME` directory.

    ##### Included plugin(s)
    ```viml
    " group 'youcompleteme'
    Plug 'Valloric/YouCompleteMe'
    ```

- ### Task `git_config`
    Requirement: `git`

    This task will ask you what username and email you want to config global
    for git.

- ### Task `git_dmtool`
    Requirement: `MAC`, `git`, `Kaleidoscope`(`ksdiff`)

    Config git's difftool and mergetool to Kaleidoscope.

    Kaleidoscope is a sooooo excellent diff and merge tool

- ### Task `git_extras`
    Requirement: `git`

    Install `git-extras` plugin for git. git-extras( _Linux, OS X_ ) has some
    useful tools for git.

- ### Task `git_flow`
    Requirement: `git`

    Install `git-flow` plugin for git.

    A post about git-flow:
    [a-successful-git-branching-model](http://nvie.com/posts/a-successful-git-branching-model/)

- ### Task `astyle_rc`
    Requirement: `astyle`. If you have installed `astyle` and press `Q` in vim,
    astyle will be used to format the *C*, *C++*, *C#*, *Java* file.

    __What others maybe you should install?__

    astyle

        # OS X only
        brew install astyle

- ### Task `sublime2`
    Requirement: `git`, `Sublime Text 2`

    **bakup your preference file first!**

    If you use `Sublime Text 2`, this task will add user Preference,
    [`Monokai Extended`](https://github.com/jonschlinkert/sublime-monokai-extended)
    colorscheme and
    [`Markdown Extended`](https://github.com/jonschlinkert/sublime-markdown-extended)
    plugin which supports more files including Markdown highlight.

    After installing the preference, maybe you want to reset `font_face` and
    `font_size` to what you prefer in `Preference.sublime-settings`. Also you
    can see what sublime packages I used in [SublimePackages](sublime/README.md).

    If you use `VIM Mode` in Sublime Text 2 on OS X 10.8+, when you hold `h`,
    `l`, `j`, `k`, the cursor will not move `left` `right` `down` `up`
    continually like real VIM, the solution is below.

    > Mac OS X Lion introduced a new, iOS-like context menu when you press and hold a key
    > that enables you to choose a character from a menu of options. If you are on Lion
    > try it by pressing and holding down 'e' in any app that uses the default NSTextField
    > for input.

    > It's a nice feature and continues the blending of Mac OS X and iOS features. However,
    > it's a nightmare to deal with in Sublime Text 2 if you're running Vintage (Vim) mode,
    > as it means you cannot press and hold h/j/k/l to move through your file. You have
    > to repeatedly press the keys to navigate.

    > You can disable this feature for just Sublime Text 2 by issuing the following command
    > in your terminal:

    >       defaults write com.sublimetext.2 ApplePressAndHoldEnabled -bool false

    > Alternately, if you want this feature disabled globally, you can enter this:

    >       defaults write -g ApplePressAndHoldEnabled -bool false

    > In either case you'll need to restart your computer for the change to take place.

    > Happy coding!

- ### Task `sublime3`
    Requirement: `git`, `Sublime Text 3`

    **bakup your preference file first!**

    If you use `Sublime Text 3`, this task will add user Preference,
    [`Monokai Extended`](https://github.com/jonschlinkert/sublime-monokai-extended)
    colorscheme and
    [`Markdown Extended`](https://github.com/jonschlinkert/sublime-markdown-extended)
    plugin which supports more files including Markdown highlight.

- ### Task `editorconfig`

    Install global `.editorconfig` to you home. You can see
    [what config is used](editorconfig).

- ### Task `zsh_rc`
    Requirements: `git`, `zsh`

    If you have your own aliases, put them in `~/.zshrc.alias`, zsh will load
    them automatically.

    __What zsh plugins are used default?__

    - colored-man-pages
    - encode64
    - extract
    - fzf-zsh(fzf)
    - sublime
    - sudo
    - zsh_reload
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - zsh-autosuggestions-conf

    __What zsh plugins are used when relational programs installed?__

    - brew          (when brew is installed)
    - fasd          (when fasd is installed, otherwise z is used)
    - gitfast       (when git is installed)
    - git-extras    (when git is installed)
    - git-flow      (when git is installed)
    - httpie        (when httpie is installed)
    - mosh          (when mosh is installed)
    - thefuck       (when thefuck is installed)
    - tmux          (when tmux is installed)
    - osx           (OS X only)

    So, maybe you should install some of them to make full use of zsh.

- ### Task `zsh_plugins_fasd`
    Requirements: `git`, `zsh`, [task zsh_rc](#task-zsh_rc)

    Install oh-my-zsh plugin `fasd`, replace default `z`

- ### Task `zsh_plugins_fzf`
    Requirements: `git`, `zsh`, [task zsh_rc](#task-zsh_rc)

    Install oh-my-zsh plugin `fzf`

- ### Task `zsh_plugins_thefuck`
    Requirements: `git`, `zsh`, [task zsh_rc](#task-zsh_rc)

    Install oh-my-zsh plugin `thefuck`

- ### Task `tmux`
    Requirements: `git`, `tmux`

    tmux plugins
    - tmux-plugins/tpm
    - tmux-plugins/tmux-sensible
    - tmux-plugins/tmux-pain-control
    - tmux-plugins/tmux-prefix-highlight
    - tmux-plugins/tmux-copycat
    - tmux-plugins/tmux-yank

## License

The MIT License (MIT)

Copyright (c) 2013-2016 Treri treri.liu@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
