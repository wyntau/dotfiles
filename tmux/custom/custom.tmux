#!/usr/bin/env bash

function mouse_scroll(){
  # If you want use mosh on server, and enable mouse report(scroll or select),
  # you should use mosh version >=1.2.5

  # these four options is only available brefore tmux 2.1
  # was deleted in tmux 2.2
  tmux set-window-option -g mode-mouse on 2>/dev/null
  tmux set-window-option -g mouse-resize-pane on 2>/dev/null
  tmux set-window-option -g mouse-select-pane on 2>/dev/null
  tmux set-window-option -g mouse-select-window on 2>/dev/null

  # `mouse` option was added in tmux 2.1
  tmux set-window-option -g mouse on 2>/dev/null
}

function vi_style_copy_paste(){
  tmux set-window-option -g mode-keys vi
  # VI-style copy/paste (http://jasonwryan.com/blog/2011/06/07/copy-and-paste-in-tmux/)
  # unbind-key [
  tmux bind-key Escape copy-mode
  tmux unbind-key p
  tmux bind-key p paste-buffer

  if [[ `tmux -V | cut -d" " -f2` < 2.4 ]]; then
    tmux bind-key -t vi-copy v begin-selection
    tmux bind-key -t vi-copy y copy-selection
    tmux bind-key -t vi-copy C-v rectangle-toggle
  else
    tmux bind-key -T copy-mode-vi v send -X begin-selection
    tmux bind-key -T copy-mode-vi y send -X copy-selection
    tmux bind-key -T copy-mode-vi C-v send -X rectangle-toggle
  fi;
}

function swap_panel(){
  # 交换两个窗格
  tmux bind-key C-u swapp -U # 与上窗格交换 Ctrl-u
  tmux bind-key C-d swapp -D # 与下窗格交换 Ctrl-d
}

function status_style(){
  ## status bar
  tmux set-option -g status-left "#[fg=green]S:#S #[fg=yellow]W:#I #[fg=cyan]P:#P"
  tmux set-option -g status-left-length 30
  # status line variables document http://linux.die.net/man/3/strftime
  tmux set-option -g status-right "#{prefix_highlight} #[fg=cyan]#(date +'%Y-%m-%d %H:%M') " # right part: time lisk 23:59
  tmux set-option -g status-right-length 30 # more space left for center part (window names)
  tmux set-option -g status-justify centre

  # 下面两行设置状态行的背景和前景色:
  tmux set-option -g status-bg default
  tmux set-option -g status-fg white

  tmux set-option -g window-status-format '#I:#W'
  tmux set-option -g window-status-current-format '[#I:#W*]'
  tmux set-window-option -g window-status-current-fg red
  tmux set-window-option -g window-status-current-bg default
  tmux set-window-option -g window-status-current-attr bright
}

function panel_style(){
  # pane border style
  tmux set-option -g pane-border-bg default
  tmux set-option -g pane-border-fg blue
  tmux set-option -g pane-active-border-bg default
  tmux set-option -g pane-active-border-fg red
}

function vim_tmux_navigation(){
  # work with vim plugin 'christoomey/vim-tmux-navigator'
  # Smart pane switching with awareness of Vim splits.
  # See: https://github.com/christoomey/vim-tmux-navigator
  local is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
  tmux bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
  tmux bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
  tmux bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
  tmux bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
  tmux bind-key -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
  tmux bind-key C-l send-keys 'C-l'

  # # If you want to navigate between vim, fzf buffer and tmux, please use below config
  # # See https://blog.bugsnag.com/tmux-and-vim/
  # is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
  #   | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
  # is_fzf="ps -o state= -o comm= -t '#{pane_tty}' \
  #   | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?fzf$'"
  # tmux bind-key -n C-h run "($is_vim && tmux send-keys C-h) || \
  #                  tmux select-pane -L"
  # tmux bind-key -n C-j run "($is_vim && tmux send-keys C-j)  || \
  #                  ($is_fzf && tmux send-keys C-j) || \
  #                  tmux select-pane -D"
  # tmux bind-key -n C-k run "($is_vim && tmux send-keys C-k) || \
  #                  ($is_fzf && tmux send-keys C-k)  || \
  #                  tmux select-pane -U"
  # tmux bind-key -n C-l run "($is_vim && tmux send-keys C-l) || \
  #                  tmux select-pane -R"
  # tmux bind-key -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
  # tmux bind-key C-l send-keys 'C-l'
}

function misc_config(){
  # 执行命令，比如看 Manpage
  tmux bind-key m command-prompt "splitw -h 'exec man %%'"

  # switch to a new session inside tmux session
  # see http://stackoverflow.com/questions/16398850/create-new-tmux-session-from-inside-a-tmux-session
  tmux bind-key e command-prompt -p 'new session name' 'new -s %1'

  # Start windows and panes at 1, not 0
  tmux set-option -g base-index 1
  tmux set-window-option -g pane-base-index 1

  # let the window be renamed automatically when launching a process
  # but prevent renaming once you have manually changed it.
  tmux set-option -g allow-rename off
}

function load_user_config(){
  if [[ -e ~/.tmux.conf.local ]]; then
    tmux source-file ~/.tmux.conf.local
  fi;
}

function main(){
  mouse_scroll
  vi_style_copy_paste
  swap_panel
  status_style
  panel_style
  vim_tmux_navigation
  misc_config
  load_user_config
}

main
