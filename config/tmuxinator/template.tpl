# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
root: .
startup_window: shell
windows:
  - shell:
      layout: 9a86,208x57,0,0{104x57,0,0,1,103x57,105,0[103x28,105,0,4,103x28,105,29,5]}
      panes:
        - /opt/splashScreen.sh
        - htop
        - docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock --name workbench-ctop quay.io/vektorlab/ctop:latest
  - editor:
      panes:
        - vim .
  - k9s:
      panes:
        - k9s
