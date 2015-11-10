## How to enable italic font support in terminal vim?

#### Terminal
Like iTerm2, gnome-terminal or else

1. cd this directory
2. run `tic xterm-256color-italic.terminfo`
3. change termial `TERM` report to `xterm-256color-italic`

**Trouble Shooting**

If your ssh server renders incorrectly and doesn't have `xterm-256color-italic` terminfo, you can

1. run same steps above in your ssh server to add `xterm-256color-italic` terminfo, or
2. set `alias ssh="TERM=xterm-256color ssh"` or `alias ssh="TERM=xterm ssh"` or
something else in your local environment to use normal terminfo in you ssh server.

#### tmux
1. enter tmux session
2. cd this directory
3. run `tic screen-256color-italic.terminfo`
4. add `set-option -g default-terminal "screen-256color-italic"` in you `~/.tmux.conf.local`

See also [Enabling italic fonts in iTerm2, tmux, and vim](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)
