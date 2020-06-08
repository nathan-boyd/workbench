# /home/me/.config/tmuxinator/{{ .Env.PROJECT_DIR }}.yml

name: {{ .Env.PROJECT_DIR }}
root: .
startup_window: home
windows:
  - home:
      layout: 257c,208x57,0,0{122x57,0,0,0,85x57,123,0,3}
      panes:
        - vim .
        - /opt/splashScreen.sh
  - shell:
      layout: 9a86,208x57,0,0{104x57,0,0,1,103x57,105,0[103x28,105,0,4,103x28,105,29,5]}
      panes:
        - /bin/zsh
        - htop
        - docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock --name workbench-ctop quay.io/vektorlab/ctop:latest
  - k9s:
      panes:
        - k9s
