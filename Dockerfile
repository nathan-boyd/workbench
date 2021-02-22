FROM ubuntu:20.04

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

# add man pages
RUN yes | unminimize && \
  apt-get install -y man-db && \
  rm -r /var/lib/apt/lists/*

ENV HOME /home/${USER_NAME}
WORKDIR ${HOME}

# set timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# enable core dumps for sudo
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
      apt-transport-https \
      atool \
      autojump \
      build-essential \
      ca-certificates \
      cowsay \
      ctop \
      ctags \
      curl \
      dnsutils \
      file \
      git \
      gcc \
      gnupg-agent \
      htop \
      httpie \
      jq \
      less \
      locales \
      mtr \
      ncdu \
      neovim \
      python3-dev \
      python3-pip \
      pylint \
      ripgrep \
      ruby \
      ruby-dev \
      neofetch \
      software-properties-common \
      ssh-client \
      sshfs \
      sudo \
      tmux \
      tree \
      w3m \
      wget \
      xclip \
      zsh \
      unzip \
      unixodbc-dev \
  && apt-get clean

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

# update / install apt sources
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && touch /etc/apt/sources.list.d/kubernetes.list \
  && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash \
  && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
  && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sudo sh -c 'echo "deb [arch=amd64] \
      https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod \
      $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && rm packages-microsoft-prod.deb \
  && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update \
  && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    kubectl \
    nodejs \
    dotnet-sdk-3.1 \
    msodbcsql17 \
    mssql-tools \
    unixodbc-dev \
    cargo \
  && apt-get clean

RUN cargo install \
  tokei \
  procs \
  navi

RUN git clone https://github.com/denisidoro/cheats $HOME/.local/share/navi/cheats

RUN ln -s $HOME/.cargo/bin/tokei /usr/local/bin/tokei \
  && ln -s $HOME/.cargo/bin/procs /usr/local/bin/procs \
  && ln -s $HOME/.cargo/bin/navi /usr/local/bin/navi

ENV PATH="$PATH:/usr/bin/node:/usr/local/go/bin"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

RUN export DOCKERVERSION=18.03.1-ce \
  && curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz" \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/.fzf && /usr/local/.fzf/install \
  && gem instal tmuxinator


RUN curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
  -o /usr/local/share/zsh/site-functions/_tmuxinator

RUN export GO_VERSION=1.14.2 \
  && curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o - | tar -xz -C /usr/local \
  && export GO111MODULE=on \
    && go get golang.org/x/tools/gopls@latest \
    && go get github.com/cweill/gotests/... \
    && go get github.com/fatih/gomodifytags \
    && go get golang.org/x/tools/cmd/goimports \
    && go get github.com/onsi/ginkgo/ginkgo \
    && go get github.com/onsi/gomega/... \
    && go get github.com/jesseduffield/lazydocker \
    && go get sigs.k8s.io/kind@v0.8.1 \
    && go get -u github.com/cheat/cheat/cmd/cheat

RUN git clone https://github.com/cheat/cheatsheets $HOME/.config/cheat/cheatsheets/community
COPY --chown=${USER_ID}:${USER_ID} config/cheat/cheatsheets ${HOME}/.config/cheat/cheatsheets

RUN curl https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz  -o- -L | tar -xz -C /usr/local/bin/ \
  && pip3 install git+https://github.com/jeffkaufman/icdiff.git \
  && pip3 install glances \
  && pip3 install --user jedi \
  && pip3 install --user rope \
  && pip3 install --user pipenv \
  && pip3 install pynvim \
  && pip3 install ranger-fm \
  && pip3 install yapf \
  && pip3 install jrnl

RUN export BAT_VERSION="0.15.4" \
  && wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" \
  && dpkg -i "bat_${BAT_VERSION}_amd64.deb" \
  && rm "bat_${BAT_VERSION}_amd64.deb"

RUN curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64 \
  && chmod 755 /usr/local/bin/gomplate \
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
  && curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
  && /usr/bin/unzip terraform_0.12.26_linux_amd64.zip \
  && mv terraform /usr/local/bin \
  && rm terraform_0.12.26_linux_amd64.zip

# create user and group to run under
RUN groupadd docker \
  && useradd -u ${USER_ID} ${USER_NAME} --shell /bin/zsh \
  && chown -R ${USER_ID}:${USER_ID} ${HOME} && \
  echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

RUN gpasswd -a $USER_NAME docker

WORKDIR ${HOME}

# install vim-plug
RUN curl -fLo .config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY --chown=${USER_ID}:${GROUP_ID} config/nvim/init.vim .config/nvim/init.vim
COPY --chown=${USER_ID}:${GROUP_ID} config/coc/package.json .config/coc/extensions/package.json

# install nvim plugins
RUN nvim --headless +PlugInstall +qall!

# install coc extensions
RUN cd $HOME/.config/coc/extensions \
  && npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# install coc dependencies
RUN npm install -g bash-language-server \
  && npm install -g tldr

RUN tldr -u

# install and configure oh-my-zsh
ENV ZSH="${HOME}/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

RUN cp "$HOME/go/pkg/mod/github.com/cheat/cheat@v0.0.0-20201128162709-883a17092f08/scripts/cheat.zsh" $ZSH/completions

# install and configure powerlevel10k
COPY --chown=${USER_ID}:${GROUP_ID} config/powerlevel10k/.p10k.zsh ${HOME}/.p10k.zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/powerlevel10k \
    && /usr/local/powerlevel10k/gitstatus/install

# install and configure tmux
COPY --chown=${USER_ID}:${GROUP_ID} config/tmux/.tmux.conf ${HOME}/.tmux.conf
RUN export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
  && git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm \
  &&  $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins

ENV GO111MODULE=on
ENV GOPATH=$HOME/go
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:/usr/local/go/bin:$GOBIN

# install vim-go dependencies
RUN go get golang.org/x/tools/cmd/guru@master \
  && go get github.com/davidrjenni/reftools/cmd/fillstruct@master \
  && go get github.com/rogpeppe/godef@master \
  && go get github.com/fatih/motion@master \
  && go get github.com/kisielk/errcheck@master \
  && go get github.com/go-delve/delve/cmd/dlv@master \
  && go get github.com/koron/iferr@master \
  && go get golang.org/x/lint/golint@master \
  && go get github.com/jstemmer/gotags@master \
  && go get github.com/josharian/impl@master \
  && go get github.com/golangci/golangci-lint/cmd/golangci-lint@master \
  && go get honnef.co/go/tools/cmd/keyify@master \
  && go get golang.org/x/tools/cmd/gorename@master \
  && go get github.com/klauspost/asmfmt/cmd/asmfmt@master \
  && nvim --headless +GoInstallBinaries +qall!

COPY --chown=${USER_ID}:${USER_ID} config/tmuxinator/template.tpl /opt/tmuxinator/template.tpl
COPY --chown=${USER_ID}:${USER_ID} config/ultisnip $HOME/.vim/UltiSnip
COPY --chown=${USER_ID}:${USER_ID} config/neofetch/config.conf ${HOME}/.config/neofetch/config.conf
COPY --chown=${USER_ID}:${USER_ID} config/coc/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
COPY --chown=${USER_ID}:${USER_ID} config/ranger ${HOME}/.config/ranger
COPY --chown=${USER_ID}:${USER_ID} config/python/.pylintrc ${HOME}/.pylintrc
COPY --chown=${USER_ID}:${USER_ID} config/zsh/.zshrc ${HOME}/.zshrc
COPY --chown=${USER_ID}:${USER_ID} config/jrnl/jrnl.yaml $HOME/.config/jrnl/jrnl.yaml
COPY --chown=${USER_ID}:${USER_ID} config/cheat/conf.yml ${HOME}/.config/cheat/conf.yml

COPY --chown=${USER_ID}:${USER_ID} scripts/splashScreen.sh /opt/splashScreen.sh
COPY --chown=${USER_ID}:${USER_ID} scripts/getscrumupdates.sh /opt/getscrumupdates.sh
COPY --chown=${USER_ID}:${USER_ID} scripts/checkcolors.sh /opt/checkcolors.sh

RUN chown \
  --silent \
  --no-dereference \
  --recursive \
  ${USER_ID}:${GROUP_ID} \
  $HOME

#USER $USER_NAME
