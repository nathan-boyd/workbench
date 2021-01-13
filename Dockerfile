FROM ubuntu:20.04

ARG USER_ID
ARG GROUP_ID

# add man pages
RUN yes | unminimize && \
    apt-get install -y man-db && \
    rm -r /var/lib/apt/lists/*

ENV USER_NAME me
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
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    touch /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
        && dpkg -i packages-microsoft-prod.deb \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
      && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
      && sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list' \
      && rm packages-microsoft-prod.deb \
    && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        azure-functions-core-tools-3 \
        kubectl \
        nodejs \
        dotnet-sdk-3.1 \
        msodbcsql17 \ 
        mssql-tools \
        unixodbc-dev \
    && apt-get clean

ENV PATH="$PATH:/usr/bin/node:/usr/local/go/bin"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

RUN export DOCKERVERSION=18.03.1-ce \
    && curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz" \
    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
    && rm docker-${DOCKERVERSION}.tgz \
  && git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/.fzf && /usr/local/.fzf/install \
  && gem instal tmuxinator \
  && curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
    -o /usr/local/share/zsh/site-functions/_tmuxinator \
  && export GO_VERSION=1.14.2 \
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
  && curl https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz  -o- -L | tar -xz -C /usr/local/bin/ \
  && pip3 install git+https://github.com/jeffkaufman/icdiff.git \
  && pip3 install glances \
  && pip3 install --user jedi \
  && pip3 install --user rope \
  && pip3 install --user pipenv \
  && pip3 install pynvim \
  && pip3 install ranger-fm \
  && pip3 install yapf \
  && export BAT_VERSION="0.15.4" \
    && wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" \
    && dpkg -i "bat_${BAT_VERSION}_amd64.deb" \
    && rm "bat_${BAT_VERSION}_amd64.deb" \
  && curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64 \
    && chmod 755 /usr/local/bin/gomplate \
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
  && curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

  RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
    && /usr/bin/unzip terraform_0.12.26_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_0.12.26_linux_amd64.zip

# install coc extensions
WORKDIR ${HOME}/.config/coc/extensions

COPY config/coc/package.json .
RUN /usr/bin/npm install --ignore-scripts --no-lockfile --production

WORKDIR ${HOME}

RUN /usr/bin/npm install --ignore-scripts --no-lockfile --production --global bash-language-server

# install vim-plug
RUN curl -fLo ${HOME}/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install and configure oh-my-zsh
ENV ZSH_CUSTOM=/home/me/.oh-my-zsh/custom
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install and configure powerlevel10k
COPY config/powerlevel10k/.p10k.zsh ${HOME}/.p10k.zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/powerlevel10k \
    && /usr/local/powerlevel10k/gitstatus/install

# install and configure tmux
COPY config/tmux/.tmux.conf ${HOME}/.tmux.conf
COPY config/nvim/init.vim ${HOME}/.config/nvim/init.vim
RUN export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
    && git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm \
    &&  $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins

ENV GO111MODULE=on
ENV GOPATH=$HOME/go
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:/usr/local/go/bin:$GOBIN

# install nvim plugins and dependencies
RUN nvim --headless +PlugInstall +qall \
&& nvim --headless +OmniSharpInstall +qall

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
&& go get github.com/klauspost/asmfmt/cmd/asmfmt@master

RUN nvim --headless +GoInstallBinaries +qall

# create user to run under
RUN groupadd workbench && \
    useradd ${USER_NAME} --shell /bin/zsh -g workbench && \
    chown -R ${USER_NAME}: ${HOME} && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

RUN chown --changes \
    --silent \
    --no-dereference \
    --recursive \
    --from=33:33 \
    ${USER_ID}:${GROUP_ID} \
    /home/me

COPY config/tmuxinator/template.tpl /opt/tmuxinator/template.tpl
COPY config/zsh/.zshrc ${HOME}/.zshrc
COPY config/ultisnip $HOME/.vim/UltiSnip
COPY config/neofetch/config.conf ${HOME}/.config/neofetch/config.conf
COPY config/git/.gitconfig ${HOME}/.gitconfig
COPY config/coc/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
COPY config/ranger ${HOME}/.config/ranger
COPY config/python/.pylintrc ${HOME}/.pylintrc

COPY scripts/entrypoint.sh /opt/entrypoint.sh
COPY scripts/splashScreen.sh /opt/splashScreen.sh
COPY scripts/workbenchStop.sh /opt/workbenchStop.sh

USER me
