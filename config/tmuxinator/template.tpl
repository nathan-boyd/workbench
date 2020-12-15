# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
startup_window: shell
on_project_stop: docker container kill workbench-{{ .Env.PROJECT_DIR }}
windows:
  - shell:
    - /opt/splashScreen.sh
