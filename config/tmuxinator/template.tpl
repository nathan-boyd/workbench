# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
root: .
startup_window: shell
on_project_stop: docker container kill workbench-{{ .Env.PROJECT_DIR }}
windows:
  - shell:
      layout: 304f,238x58,0,0[238x38,0,0,0,238x19,0,39,4]
      panes:
        - zsh:
          - /bin/zsh
        - glances:
          - glances
  - editor:
      panes:
        - vim .
  - ctop:
      panes:
        - docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock --name workbench-workbench-ctop quay.io/vektorlab/ctop:latest
  - k9s:
      panes:
        - k9s
