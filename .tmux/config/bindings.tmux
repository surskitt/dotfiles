unbind C-b
set -g prefix C-a

unbind C-o
bind C-o select-pane -t :.+
bind c new-window -n ''
bind S command-prompt -p " new session:" "new-session -s %1 -n ''"
bind C-h select-pane -L
bind C-j select-pane -D
bind C-k select-pane -U
bind C-l select-pane -R
bind > swap-pane -D
bind < swap-pane -U
bind -n C-S-Left swap-window -t -1
bind -n C-S-Right swap-window -t +1
unbind n
unbind h
bind h previous-window
unbind l
bind l next-window
bind j switch-client -n
bind k switch-client -p
bind - split-window -v
bind = split-window -h
bind @ setw synchronize-panes
unbind C-a
bind C-a last-window
bind C-p last-pane
bind r source-file ~/.tmux.conf \; display "Reloaded config file"
unbind [
bind Escape copy-mode
unbind p
bind p paste-buffer
bind n set -g pane-border-status
bind b run-shell ~/.scripts/tmux_balance.sh
bind . attach-session -c '#{pane_current_path}' \; display "Set session path to #{pane_current_path}"
