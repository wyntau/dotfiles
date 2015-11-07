## How to enable italic font support in terminal vim?

#### Terminal
Like iTerm2, gnome-terminal or else

1. cd this directory
2. run `tic xterm-256color-italic.terminfo`
2. change termial `TERM` report to `xterm-256color-italic`

#### tmux
1. enter tmux session
2. cd this directory
3. run `tic screen-256color-italic.terminfo`
4. add `set-option -g default-terminal "screen-256color-italic"` in you `~/.tmux.conf.local`

See also [Enabling italic fonts in iTerm2, tmux, and vim](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)
