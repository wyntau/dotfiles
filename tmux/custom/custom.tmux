#!/usr/bin/env bash

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
  vi_style_copy_paste
  status_style
  panel_style
  misc_config
  load_user_config
}

main
