#!/usr/bin/env nu

let editor = $env.EDITOR | default "nano"
let generated_startup_config_path = '/tmp/tmux_startup.conf'
let scrollback_path = '/tmp/tmux-scrollback.txt'

def set_bindings [key_table] {
  let bind_prefix = $"bind -T ($key_table)"

  $in | each {|binding_info|
    $"($bind_prefix) \"($binding_info.0)\" { ($binding_info.2) }"
  } | str join "\n"
}


let status_left_style_root = "set -g status-left-style 'fg=white,bg=black'"
let status_left_style_prefix = "set -g status-left-style 'fg=red,bg=black'"
let status_left_style_copy = "set -g status-left-style 'fg=yellow,bg=black'"


let root_bindings = [
  ["C-g" "Prefix Mode" $"set -g key-table prefix; ($status_left_style_prefix)"]
  ["C-b" "Copy Mode" $"copy-mode; ($status_left_style_copy)"]
]
let prefix_bindings = [
  ["Escape" "Root Mode" $"set -g key-table root; ($status_left_style_root)"]
  ["=" "Equalize panes" "selectl tiled"]
  ["q" "Close pane" "killp"]
  ["Q" "Close window" "killw"]
  ["e" "Edit scrollback" $"capturep -S -; saveb ($scrollback_path); deleteb; neww '($editor) ($scrollback_path)'"]
  ["y" "Split right" "splitw -h"]
  ["Y" "Split left" "splitw -hb"]
  ["s" "Synchronize panes" "if -F '#{!=:#{window_panes},1}' { set -w synchronize-panes }"]
  ["d" "Detach client" "detach"]
  ["f" "Fullscreen pane" "resizep -Z"]
  ["h" "Go left" "if -F '#{pane_at_left}' {
    if -F '#{!=:#{window_start_flag},1}' {
      prev; selectp -t '{right}'
    }
  } {
    selectp -L
  }"]
  ["H" "Move left" "if -F '#{pane_at_left}' {
    if -F '#{&&:#{pane_at_bottom},#{pane_at_top}}' {
      if -F '#{!=:#{session_windows},1}' {
        if -F '#{!=:#{window_start_flag},1}' {
          joinp -fh -t '{previous}.{right}'
        }
      } {
        if -F '#{!=:#{window_panes},1}' {
          breakp -b
        }
      }
    } {
      breakp -b; joinp -fhb -t '{next}.{left}'
    }
  } {
    joinp -fv -t '{left-of}'
  }"]
  ["j" "Go down" "if -F '#{!=:#{pane_at_bottom},1}' { selectp -D }"]
  ["J" "Move down" "if -F '#{pane_at_bottom}' {
    if -F '#{!=:#{&&:#{pane_at_left},#{pane_at_right}},1}' {
      breakp -b; joinp -fv -t '{next}.{bottom}'
    }
  } {
    join -fh -t '{down-of}'
  }"]
  ["k" "Go up" "if -F '#{!=:#{pane_at_top},1}' { selectp -U }"]
  ["K" "Move up" "if -F '#{pane_at_top}' {
    if -F '#{!=:#{&&:#{pane_at_left},#{pane_at_right}},1}' {
      breakp -b; joinp -fvb -t '{next}.{top}'
    }
  } {
    join -fh -t '{up-of}'
  }"]
  ["l" "Go right" "if -F '#{pane_at_right}' {
    if -F '#{!=:#{window_end_flag},1}' {
      next; selectp -t '{left}'
    }
  } {
    selectp -R
  }"]
  ["L" "Move right" "if -F '#{pane_at_right}' {
    if -F '#{&&:#{pane_at_bottom},#{pane_at_top}}' {
      if -F '#{!=:#{session_windows},1}' {
        if -F '#{!=:#{window_end_flag},1}' {
          joinp -fhb -t '{next}.{left}'
        }
      } {
        if -F '#{!=:#{window_panes},1}' {
          breakp -a
        }
      }
    } {
      breakp -b; joinp -fh -t '{next}.{right}'
    }
  } {
    join -fv -t '{right-of}'
  }"]
  ["x" "Split down" "splitw -v"]
  ["X" "Split up" "splitw -vb"]
  ["n" "New window" "neww"]
  [":" "Command Prompt" "command-prompt"]
  ["Enter" "Reload config" $"run '($env.FILE_PWD)/startup.nu'"]
  ["Left" "Increase pane left" "resizep -L 1"]
  ["Down" "Increase pane down" "resizep -D 1"]
  ["Up" "Increase pane up" "resizep -U 1"]
  ["Right" "Increase pane right" "resizep -R 1"]
]
let copy_bindings = [
  ["Escape" "Root Mode" $"send -X 'cancel'; set -g key-table root; ($status_left_style_root)"]
  ["h" "Cursor left" "send -X 'cursor-left'"]
  ["j" "Cursor down" "send -X 'cursor-down'"]
  ["k" "Cursor up" "send -X 'cursor-up'"]
  ["l" "Cursor right" "send -X 'cursor-right'"]
]


$"
set -g aggressive-resize off
set -g base-index 1
set -g default-terminal '($env.TERM)'
set -g editor '($editor)'
set -g escape-time 0
set -g focus-events off
set -g history-limit 10000
set -g mode-keys vi
set -g mouse on
set -g pane-base-index 1
set -g renumber-windows on
set -g set-clipboard on
set -g status-keys vi

set -g pane-border-style 'fg=white'
set -g pane-active-border-style 'fg=red'

set -g status-position top
set -g key-table root
($status_left_style_root)
set -g status-left '#[reverse] #[noreverse]  #[reverse] #S #[noreverse]'
set -g status-left-length 25
set -g status-right '  '
set -g status-justify centre
set -g status-style ''
set -g window-status-current-format '#[fg=brightwhite,bold,italics]  #I ➢ #W#{?pane_synchronized, ,}#{?window_zoomed_flag, 󰹙,}  #[nobold,noitalics]'
set -g window-status-format '#[fg=white]  #I ➢ #W#{?pane_synchronized, ,}#{?window_zoomed_flag, 󰹙,}  '
set -g window-status-separator '·'
set -g message-style 'fg=brightwhite,bg=black'

set-hook -g after-kill-pane 'if -F \"#{==:#{window_panes},1}\" { set -w synchronize-panes off } {}'

set -g prefix None
unbind -T root -a
unbind -T prefix -a
unbind -T copy-mode-vi -a

($root_bindings | set_bindings 'root')
($prefix_bindings | set_bindings 'prefix')
($copy_bindings | set_bindings 'copy-mode-vi')
" | save --force $generated_startup_config_path

tmux source $generated_startup_config_path
