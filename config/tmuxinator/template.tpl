# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
root: .

# Runs on project start, always
# on_project_start: command

# Run on project start, the first time
# on_project_first_start: command

# Run on project start, after the first time
# on_project_restart: command

# Run on project exit ( detaching from tmux session )
on_project_exit: docker stop workbench-ctop

# Run on project stop
# on_project_stop: command

# Runs in each window and pane before window/pane specific commands. Useful for setting up interpreter versions.
# pre_window: rbenv shell 2.0.0-p247

# Pass command line options to tmux. Useful for specifying a different tmux.conf.
# tmux_options: -f ~/.tmux.mac.conf

# Change the command to call tmux.  This can be used by derivatives/wrappers like byobu.
# tmux_command: byobu

# Specifies (by index) which pane of the specified window will be selected on project startup. If not set, the first pane is used.
# startup_pane: 1

# Controls whether the tmux session should be attached to automatically. Defaults to true.
# attach: false

startup_window: home
windows:
  - home:
      layout: 257c,208x57,0,0{122x57,0,0,0,85x57,123,0,3}
      panes:
        - vim .
        - /opt/splashScreen.sh
  - shell:
      panes:
  - top:
      layout: even-horizontal
      panes:
        top: top
        ctop: docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock --name workbench-ctop quay.io/vektorlab/ctop:latest
  - k9s:
      panes: k9s
