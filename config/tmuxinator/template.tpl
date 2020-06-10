# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
root: .
startup_window: shell
on_project_stop: docker container kill workbench-{{ .Env.PROJECT_DIR }}
windows:
  - shell:
      layout: 722b,208x57,0,0[208x38,0,0,0,208x18,0,39{104x18,0,39,5,103x18,105,39,6}]
      panes:
        - /bin/zsh
        - htop
        - docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock --name workbench-{{ .Env.PROJECT_DIR }}-ctop quay.io/vektorlab/ctop:latest
  - editor:
      panes:
        - vim .
  - k9s:
      panes:
        - k9s
