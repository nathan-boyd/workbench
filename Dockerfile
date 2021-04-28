FROM ubuntu:20.04

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

ENV HOME /home/${USER_NAME}
ENV TZ=America/New_York

WORKDIR ${HOME}

# install standard ubuntu pacakges
RUN yes | unminimize \
  && apt-get install -y man-db \
  && rm -r /var/lib/apt/lists/*

# set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# enable core dumps for sudo
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# install base packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
    apt-transport-https \
    atool \
    autoconf \
    autojump \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    cowsay \
    ctags \
    ctop \
    curl \
    dnsutils \
    file \
    g++ \
    gcc \
    gettext \
    git \
    gnupg-agent \
    htop \
    httpie \
    inotify-tools \
    jq \
    less \
    libtool \
    libtool-bin \
    locales \
    lua5.3 \
    mtr \
    ncdu \
    neofetch \
    ninja-build \
    pkg-config \
    pylint \
    python2 \
    python3-dev \
    python3-pip \
    ripgrep \
    ruby \
    ruby-dev \
    software-properties-common \
    ssh-client \
    sshfs \
    sudo \
    tmux \
    tree \
    unzip \
    w3m \
    wget \
    xclip \
    xfonts-utils \
    zsh \
  && apt-get clean

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

RUN groupadd docker

RUN useradd -u ${USER_ID} ${USER_NAME} --shell /bin/zsh  --create-home --home-dir $HOME \
  && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

RUN gpasswd -a $USER_NAME docker

RUN chown \
  -c \
  --no-dereference \
  --recursive \
  ${USER_ID} \
  $HOME

# update / install apt sources
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && touch /etc/apt/sources.list.d/kubernetes.list \
  && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash 

USER ${USER_NAME}

RUN sudo apt-get update \
  && sudo ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    kubectl \
    nodejs \
    cargo \
    fortune-mod \
  && sudo apt-get clean

RUN export VERSION="v4.6.1" \
  && export BINARY="yq_linux_amd64" \
  && wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - | sudo tar xz \
  && sudo mv ${BINARY} /usr/bin/yq

RUN mkdir -p $HOME/.local/share/navi/cheats \
  && git clone https://github.com/denisidoro/cheats $HOME/.local/share/navi/cheats

ENV PATH="$PATH:/usr/bin/node:/usr/local/go/bin"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

RUN export DOCKERVERSION=18.03.1-ce \
  && curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz" \
  && sudo tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/.fzf \
  && $HOME/.local/.fzf/install

RUN sudo gem instal tmuxinator

RUN sudo curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
  -o /usr/local/share/zsh/site-functions/_tmuxinator

ENV GO111MODULE=on
ENV GOPATH=$HOME/go
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:/usr/local/go/bin:$GOBIN

ENV PATH="${HOME}/.local/bin:${PATH}"

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py \
  && python2 get-pip.py \
  && rm get-pip.py \
  && pip2 --version

RUN export GO_VERSION=1.16.3 \
  && sudo curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o - | sudo tar -xz -C /usr/local

RUN export GO111MODULE=on \
  && go get -u github.com/stamblerre/gocode

RUN git clone https://github.com/nathan-boyd/project-name-generator \
  && cd project-name-generator \
  && go install \
  && cd .. \
  && rm -rf project-name-generator

RUN go get -u github.com/cheat/cheat/cmd/cheat \
  && git clone https://github.com/cheat/cheatsheets $HOME/.config/cheat/cheatsheets/community
COPY --chown=${USER_ID}:${USER_ID} config/cheat/cheatsheets ${HOME}/.config/cheat/cheatsheets

RUN curl https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz  -o- -L | sudo tar -xz -C /usr/local/bin/ \
  && pip3 install git+https://github.com/jeffkaufman/icdiff.git \
  && pip3 install glances \
  && pip3 install jedi \
  && pip3 install jrnl \
  && pip3 install pipenv \
  && pip3 install ranger-fm \
  && pip3 install rope \
  && pip3 install yapf

RUN export BAT_VERSION="0.15.4" \
  && wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" \
  && sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb" \
  && rm "bat_${BAT_VERSION}_amd64.deb"

RUN sudo curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64 \
  && sudo chmod 755 /usr/local/bin/gomplate

RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
  && sudo /usr/bin/unzip terraform_0.12.26_linux_amd64.zip \
  && sudo mv terraform /usr/local/bin \
  && rm terraform_0.12.26_linux_amd64.zip

# install and configure oh-my-zsh
ENV ZSH="${HOME}/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# RUN sudo cp "$HOME/go/pkg/mod/github.com/cheat/cheat@v0.0.0-20201128162709-883a17092f08/scripts/cheat.zsh" $ZSH/completions

# install and configure powerlevel10k
COPY --chown=${USER_ID}:${GROUP_ID} config/powerlevel10k/.p10k.zsh ${HOME}/.p10k.zsh
RUN sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/powerlevel10k \
    && /usr/local/powerlevel10k/gitstatus/install

# install and configure tmux
COPY --chown=${USER_ID}:${GROUP_ID} config/tmux/.tmux.conf ${HOME}/.tmux.conf
RUN export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
  && git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm \
  &&  $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins

COPY --chown=${USER_ID}:${GROUP_ID} config/tmuxinator/template.tpl /opt/tmuxinator/template.tpl
COPY --chown=${USER_ID}:${GROUP_ID} config/neofetch/config.conf ${HOME}/.config/neofetch/config.conf
COPY --chown=${USER_ID}:${GROUP_ID} config/ranger ${HOME}/.config/ranger
COPY --chown=${USER_ID}:${GROUP_ID} config/python/.pylintrc ${HOME}/.pylintrc
COPY --chown=${USER_ID}:${GROUP_ID} config/zsh/.zshrc ${HOME}/.zshrc
COPY --chown=${USER_ID}:${GROUP_ID} config/jrnl/jrnl.yaml $HOME/.config/jrnl/jrnl.yaml
COPY --chown=${USER_ID}:${GROUP_ID} config/cheat/conf.yml ${HOME}/.config/cheat/conf.yml

COPY scripts/splashScreen.sh /opt/splashScreen.sh
COPY scripts/getscrumupdates.sh /opt/getscrumupdates.sh
COPY scripts/checkcolors.sh /opt/checkcolors.sh

COPY config/fortune/quotes /opt/fortune/quotes
COPY config/fortune/quotes.dat /opt/fortune/quotes.dat

#RUN apt-get update && \
#  DEBIAN_FRONTEND=noninteractive \
#  apt-get install -y --no-install-recommends \
#  neovim

# RUN sudo chown -R ${USER_ID:$GROUP_ID} $HOME/.npm
# RUN sudo chown -R ${USER_ID:$GROUP_ID} $HOME/.config

RUN sudo chown -R ${USER_ID}:${GROUP_ID} "/usr/lib/node_modules"
RUN sudo npm install --global yarn
ENV PATH="${HOME}/.yarn/bin:${PATH}"

RUN yarn global add vscode-html-languageserver-bin \
  && yarn global add -D lehre \
  && yarn global add neovim \
  && yarn global add typescript \
  && yarn global add tldr  

RUN tldr -u

# Install nvim build dependencies
RUN sudo apt-get install \
      ninja-build \
      gettext \
      libtool \
      libtool-bin \
      autoconf \
      automake \
      cmake \
      g++ \
      pkg-config unzip

RUN python2 -m pip install --upgrade pynvim
RUN python3 -m pip install --upgrade pynvim

RUN mkdir -p /tmp/usr/src \
  && cd /tmp/usr/src \
  && git clone https://github.com/neovim/neovim.git \
  && cd neovim \
  && git checkout tags/v0.4.4 \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" \
  && make install \
  && sudo rm -rf /tmp/usr/src

ENV PATH="$HOME/neovim/bin:${PATH}"

COPY --chown=${USER_ID} config/spacevim/init.toml ${HOME}/.SpaceVim.d/init.toml
COPY --chown=${USER_ID} config/spacevim/custom.vim ${HOME}/.SpaceVim.d/autoload/custom.vim
COPY --chown=${USER_ID}:${USER_ID} config/ultisnip ${HOME}/.SpaceVim.d/UltiSnips/

RUN sudo chown \
  -c \
  --no-dereference \
  --recursive \
  ${USER_ID} \
  $HOME

RUN curl -sLf https://spacevim.org/install.sh | bash

RUN nvim --headless '+call dein#install() | qa'

RUN nvim --headless '+call remote#host#UpdateRemotePlugins() | qa' 
# TODO: troubleshoop python3 remote plugins not automatically uipdating
COPY  --chown=${USER_ID} config/spacevim/rplugin.vim ${HOME}/.local/share/nvim/rplugin.vim

RUN nvim --headless +GoInstallBinaries +qa

RUN cargo install \
  tokei \
  procs \
  navi

RUN sudo ln -s $HOME/.cargo/bin/tokei /usr/local/bin/tokei \
  && sudo ln -s $HOME/.cargo/bin/procs /usr/local/bin/procs \
  && sudo ln -s $HOME/.cargo/bin/navi /usr/local/bin/navi

# RUN find $HOME -type d -print0 | xargs -0 chmod 755  
# RUN find $HOME -type f -print0 | xargs -0 chmod 644

