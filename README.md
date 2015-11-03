## What are in the repo
    dotfile
    ├── astylerc
    ├── editorconfig
    ├── git
    |   └── gitconfig
    ├── sublime2
    |   ├── Preference.sublime-settings
    |   └── README.md
    ├── sublime3
    |   ├── Preference.sublime-settings
    |   └── README.md
    ├── tmux
    │   └── tmux.conf
    ├── vim
    │   ├── init.vim -> vimrc
    │   ├── vimrc
    │   ├── vimrc.plugins
    │   ├── vimrc.plugins.fzf
    │   ├── vimrc.plugins.matchtag
    │   ├── vimrc.plugins.snippets
    │   └── vimrc.plugins.ycm
    └── zsh
        └── zshrc

## Tasks
All vailable tasks:

- [fonts_source_code_pro](#task-fonts_source_code_pro)
- [vim_rc](#task-vim_rc)
- [vim_plugins_base](#task-vim_plugins_base)
- [vim_plugins_fzf](#task-vim_plugins_fzf)
- [vim_plugins_matchtag](#task-vim_plugins_matchtag)
- [vim_plugins_snippets](#task-vim_plugins_snippets)
- [vim_plugins_ycm](#task-vim_plugins_ycm)
- [git_config](#task-git_config)
- [git_dmtool](#task-git_dmtool)
- [git_extras](#task-git_extras)
- [git_flow](#task-git_flow)
- [astylerc](#task-astylerc)
- [sublime2](#task-sublime2)
- [sublime3](#task-sublime3)
- [editorconfig](#task-editorconfig)
- [zsh_rc](#task-zsh_rc)
- [tmux](#task-tmux)

You can do a specific task by run

    ./install.sh <taskname1>[ <taskname2> <tasknameN> ...]

- ### Task `fonts_source_code_pro`
    Requirements: `git`

    This task will install [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) font for you.

    The new version font is compatible with powerline fonts which have some useful symbols used in some vim plugins and shell plugins, and it will update frequently. So use it to replace [Powerline fonts](https://github.com/powerline/fonts).

    This font will be installed automatically when do task [vim_plugins_base](#task-vim_plugins_base), [sublime2](#task-sublime2) and [sublime3](#task-sublime3).

- ### Task `vim_rc`
    Requirements: `git`, `vim`

    This task will not install any plugin, if you want to use some plugins, do __[task vim_plugins_base](#task-vim_plugins_base)__.

    You can override the system vim with the new one installed by `homebrew`.(OS X only. This is optional, but recommended, because system vim can't use system clipbord via register `+`)

        brew install macvim --with-override-system-vim

    And then add the new vim __PATH__ into your `$PATH`.

    Additionally, if you have installed `neovim`, this task will link `vim` to `~/.nvim`, `vim/vimrc` to `~/.nvimrc`.

- ### Task `vim_plugins_base`
    Requirement: `git`, `vim`, [task vim_rc](#task-vim_rc)

    Setup vim-plug, and load other plugins. After doing this task, you can load
    your own plugins in `~/.vimrc.plugins.local`

    ##### Included plugins

        Plug 'tomasr/molokai'
        Plug 'altercation/vim-colors-solarized'
        Plug 'morhetz/gruvbox'

        Plug 'CodeFalling/fcitx-vim-osx'
        Plug 'bling/vim-airline'
        Plug 'airblade/vim-gitgutter'
        Plug 'Yggdroot/indentLine'
        Plug 'tmux-plugins/vim-tmux'
        Plug 'tmux-plugins/vim-tmux-focus-events'
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'tacahiroy/ctrlp-funky'
        Plug 'scrooloose/nerdtree'
        Plug 'jistr/vim-nerdtree-tabs'
        Plug 'dyng/ctrlsf.vim'
        Plug 'Lokaltog/vim-easymotion'
        Plug 'terryma/vim-expand-region'
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'Raimondi/delimitMate'
        Plug 'godlygeek/tabular'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-repeat'
        Plug 'scrooloose/nerdcommenter'
        Plug 'terryma/vim-multiple-cursors'
        Plug 'osyo-manga/vim-over'

        Plug 'vim-scripts/matchit.zip'
        Plug 'mattn/emmet-vim'
        Plug 'plasticboy/vim-markdown'
        Plug 'leafgarland/typescript-vim'
        Plug 'kchmck/vim-coffee-script'
        Plug 'groenewege/vim-less'
        Plug 'smilekzs/vim-nfo'
        Plug 'evanmiller/nginx-vim-syntax'
        Plug 'pangloss/vim-javascript'
        Plug 'mxw/vim-jsx'
        Plug 'othree/yajs.vim'
        Plug 'Marslo/vim-coloresque'

- ### Task `vim_plugins_fzf`
    Requirement: `git`, `vim`, `curl` or `wget`, [task vim_rc](#task-vim_rc)

    Install fzf.vim plugin for vim.

    ##### Included plugins

        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'

- ### Task `vim_plugins_matchtag`
    Requirement: `git`, `vim`, `curl`, `python`, [task vim_rc](#task-vim_rc)

    Install html matchtag plugin for vim. Here i use python version matchtag.
    If you don't want to include python modules, you can also use non-python version 'gregsexton/MatchTag'

    ##### Included plugins

        Plug 'valloric/MatchTagAlways'

- ### Task `vim_plugins_snippets`
    Requirement: `git`, `vim`, `curl`, `python`, [task vim_rc](#task-vim_rc)

    Install vim-snippets plugin for vim.

    ##### Included plugins

        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'

- ### Task `vim_plugins_ycm`
    Requirement: `git`, `vim`, `curl`, `python`, [task vim_rc](#task-vim_rc)

    Install YouCompleteMe plugin for vim.

    If YouCompleteMe lib files not exist, or you force YouCompleteMe to recompile with `export YCM_COMPILE_FORCE=true`, YouCompleteMe lib files will be compiled automatically.

    Also you can set `YCM_COMPLETER` with different language support. Available languages are `clang`, `omnisharp` and `gocode`. This option is empty default.

    ##### Included plugins

        Plug 'Valloric/YouCompleteMe'

- ### Task `git_config`
    Requirement: `git`

    This task will ask you what username and email you want to config global for git

- ### Task `git_dmtool`
    Requirement: `MAC`, `git`, `Kaleidoscope`(`ksdiff`)

    Config git's difftool and mergetool to Kaleidoscope.

    Kaleidoscope is a sooooo excellent diff and merge tool

- ### Task `git_extras`
    Requirement: `git`

    Install `git-extras` plugin for git. git-extras( _Linux, OS X_ ) has some useful tools for git

- ### Task `git_flow`
    Requirement: `git`

    Install `git-flow` plugin for git.

    A post about git-flow: [a-successful-git-branching-model](http://nvie.com/posts/a-successful-git-branching-model/)

- ### Task `astylerc`
    Requirement: `astyle`. If you have installed `astyle` and press `Q` in vim, astyle will be used to format the *C*, *C++*, *C#*, *Java* file.

    __What others maybe you should install?__

    astyle

        # OS X only
        brew install astyle

- ### Task `sublime2`
    Requirement: `git`, `Sublime Text 2`

    **bakup your preference file first!**

    If you use `Sublime Text 2`, this task will add user Preference, [`Monokai Extended`](https://github.com/jonschlinkert/sublime-monokai-extended) colorscheme and [`Markdown Extended`](https://github.com/jonschlinkert/sublime-markdown-extended) plugin which supports more files including Markdown highlight.

    After installing the preference, maybe you want to reset `font_face` and `font_size` to what you prefer in `Preference.sublime-settings`. Also you can see what sublime packages I used in [SublimePackages](sublime/README.md).

    If you use `VIM Mode` in Sublime Text 2 on OS X 10.8+, when you hold `h`, `l`, `j`, `k`, the cursor will not move `left` `right` `down` `up` continually like real VIM, the solution is below.

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

    If you use `Sublime Text 3`, this task will add user Preference, [`Monokai Extended`](https://github.com/jonschlinkert/sublime-monokai-extended) colorscheme and [`Markdown Extended`](https://github.com/jonschlinkert/sublime-markdown-extended) plugin which supports more files including Markdown highlight.

- ### Task `editorconfig`

    Install global `.editorconfig` to you home. You can see [what config is used](editorconfig).

- ### Task `zsh_rc`
    Requirements: `git`, `zsh`

    If you have your own aliases, put them in `~/.zshrc.alias`, zsh will load them automatically.

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
    - gitfast       (when git is installed)
    - git-extras    (when git is installed)
    - git-flow      (when git is installed)
    - httpie        (when httpie is installed)
    - mosh          (when mosh is installed)
    - tmux          (when tmux is installed)
    - fasd          (when fasd is installed, otherwise z)
    - osx           (OS X only)

    So, maybe you should install some of them to make full use of zsh.

- ### Task `tmux`
    Requirements: `git`, `tmux`

    tmux plugins
    - tmux-plugins/tpm
    - tmux-plugins/tmux-sensible
    - tmux-plugins/tmux-pain-control
    - tmux-plugins/tmux-copycat
    - tmux-plugins/tmux-yank

## License

The MIT License (MIT)

Copyright (c) 2013-2015 Treri treri.liu@gmail.com

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
