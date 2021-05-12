FROM ubuntu:20.04

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

###############################################################################
# Install and configure layer 0 packages
###############################################################################

ENV TZ="America/New_York"
ENV DEBIAN_FRONTEND=noninteractive 

RUN echo "${TZ}" | tee /etc/timezone

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils

RUN apt-get update \
  && apt-get install -y \
    man-db \
    locales \
    sudo \
    tzdata \
    zsh

RUN dpkg-reconfigure tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 

RUN dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8

RUN yes | unminimize 

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

###############################################################################
# Create user and groups
###############################################################################

ENV HOME="/home/${USER_NAME}"

RUN groupadd -g ${GROUP_ID} docker

RUN useradd -u ${USER_ID} ${USER_NAME} \
  --shell /bin/zsh  \
  --create-home \
  --home-dir $HOME

RUN echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

RUN gpasswd -a $USER_NAME docker

USER ${USER_NAME}

WORKDIR ${HOME}

###############################################################################
# Install layer 1 dependencies
###############################################################################

RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
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
    fortune-mod \
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
    tmux \
    tree \
    unzip \
    w3m \
    wget \
    xclip \
    xfonts-utils

COPY --chown=${USER_ID}:${GROUP_ID} config/neofetch/config.conf ${HOME}/.config/neofetch/config.conf

###############################################################################
# Install pip2
###############################################################################

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py \
  && sudo python2 get-pip.py \
  && rm get-pip.py \
  && pip2 --version

###############################################################################
# Build and install NVIM 
###############################################################################

RUN python2 -m pip install --upgrade pynvim
RUN python3 -m pip install --upgrade pynvim

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

RUN export NVIM_VERSION_TAG="v0.4.4" \
  && mkdir -p /tmp/usr/src \
  && cd /tmp/usr/src \
  && git clone https://github.com/neovim/neovim.git \
  && cd neovim \
  && git checkout "tags/${NVIM_VERSION_TAG}" \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" \
  && make install \
  && sudo rm -rf /tmp/usr/src

ENV PATH="${HOME}/neovim/bin:${PATH}"

###############################################################################
# Install SpaceVim
###############################################################################

COPY --chown=${USER_ID} config/spacevim/init.toml ${HOME}/.SpaceVim.d/init.toml
COPY --chown=${USER_ID} config/spacevim/custom.vim ${HOME}/.SpaceVim.d/autoload/custom.vim
COPY --chown=${USER_ID}:${USER_ID} config/ultisnip ${HOME}/.SpaceVim.d/UltiSnips/

RUN curl -sLf https://spacevim.org/install.sh | bash
RUN nvim --headless '+call dein#install() | qa'
RUN nvim --headless '+call remote#host#UpdateRemotePlugins() | qa' 

# TODO: troubleshoot python3 remote plugins not automatically updating 
COPY  --chown=${USER_ID} config/spacevim/rplugin.vim ${HOME}/.local/share/nvim/rplugin.vim

RUN nvim --headless +GoInstallBinaries +qa

RUN sudo apt-get clean

###############################################################################
# Install Kubectl
###############################################################################

RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

RUN sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
  && sudo touch /etc/apt/sources.list.d/kubernetes.list \
  && sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

RUN sudo apt-get update \
  && sudo ACCEPT_EULA=Y apt-get install -y --no-install-recommends kubectl

###############################################################################
# Install Rust package manager, cargo, and packages 
###############################################################################

RUN sudo apt-get update \
  && sudo ACCEPT_EULA=Y apt-get install -y --no-install-recommends cargo

RUN cargo install \
  tokei \
  procs \
  navi

RUN sudo ln -s $HOME/.cargo/bin/tokei /usr/local/bin/tokei \
  && sudo ln -s $HOME/.cargo/bin/procs /usr/local/bin/procs \
  && sudo ln -s $HOME/.cargo/bin/navi /usr/local/bin/navi

###############################################################################
# Install yq
###############################################################################

RUN export VERSION="v4.6.1" \
  && export BINARY="yq_linux_amd64" \
  && wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - | sudo tar xz \
  && sudo mv ${BINARY} /usr/bin/yq

###############################################################################
# Install cheats
###############################################################################

RUN mkdir -p $HOME/.local/share/navi/cheats \
  && git clone https://github.com/denisidoro/cheats $HOME/.local/share/navi/cheats

COPY --chown=${USER_ID}:${GROUP_ID} config/cheat/conf.yml ${HOME}/.config/cheat/conf.yml



###############################################################################
# Install docker cli tool
###############################################################################

RUN export DOCKERVERSION=18.03.1-ce \
  && curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz" \
  && sudo tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

###############################################################################
# Install lazydocker
###############################################################################

RUN curl "https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh" | bash

###############################################################################
# Install fzf
###############################################################################

RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/.fzf \
  && $HOME/.local/.fzf/install

###############################################################################
# Install tmuxinator
###############################################################################

RUN sudo gem instal tmuxinator

RUN sudo curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
  -o /usr/local/share/zsh/site-functions/_tmuxinator

COPY --chown=${USER_ID}:${GROUP_ID} config/tmuxinator/template.tpl /opt/tmuxinator/template.tpl


###############################################################################
# Install GoLang
###############################################################################

ENV GO111MODULE=on
ENV GOPATH="${HOME}/go"
ENV GOBIN="${GOPATH}/bin"
ENV PATH="${PATH}:/usr/local/go/bin:${GOBIN}"
ENV PATH="${HOME}/.local/bin:${PATH}"
ENV PATH="${PATH}:/usr/bin/node:/usr/local/go/bin"

RUN export GO_VERSION=1.16.3 \
  && sudo curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o - | sudo tar -xz -C /usr/local

RUN go get -u github.com/stamblerre/gocode

###############################################################################
# Install project name generator
###############################################################################

RUN git clone https://github.com/nathan-boyd/project-name-generator \
  && cd project-name-generator \
  && go install \
  && cd .. \
  && rm -rf project-name-generator


###############################################################################
# Install K9s
###############################################################################

RUN curl https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz  -o- -L | sudo tar -xz -C /usr/local/bin/ 

###############################################################################
# Install pip3 packages
###############################################################################

RUN pip3 install git+https://github.com/jeffkaufman/icdiff.git \
  && pip3 install glances \
  && pip3 install jedi \
  && pip3 install jrnl \
  && pip3 install pipenv \
  && pip3 install ranger-fm \
  && pip3 install rope \
  && pip3 install yapf

COPY --chown=${USER_ID}:${GROUP_ID} config/ranger ${HOME}/.config/ranger
COPY --chown=${USER_ID}:${GROUP_ID} config/jrnl/jrnl.yaml $HOME/.config/jrnl/jrnl.yaml

###############################################################################
# Install bat
###############################################################################

RUN export BAT_VERSION="0.15.4" \
  && wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" \
  && sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb" \
  && rm "bat_${BAT_VERSION}_amd64.deb"

###############################################################################
# Install gomplate
###############################################################################

RUN sudo curl -o /usr/local/bin/gomplate -sSL \
  https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64

# && sudo chmod 755 /usr/local/bin/gomplate

###############################################################################
# Install terraform
###############################################################################

RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
  && sudo /usr/bin/unzip terraform_0.12.26_linux_amd64.zip \
  && sudo mv terraform /usr/local/bin \
  && rm terraform_0.12.26_linux_amd64.zip

###############################################################################
# Install oh-my-zsh
###############################################################################

ENV ZSH="${HOME}/.oh-my-zsh"
ENV ZSH_CUSTOM="${ZSH}/custom"
ENV ZSH_COMPLETIONS="${ZSH}/completion"

RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN mkdir "${ZSH_COMPLETIONS}"

###############################################################################
# Install and configure cheat
###############################################################################

ENV CHEAT_USE_FZF=true

RUN go get -u github.com/cheat/cheat/cmd/cheat 
RUN git clone https://github.com/cheat/cheatsheets "${HOME}/.config/cheat/cheatsheets/community"
RUN find "${GOPATH}/pkg/mod/github.com/cheat" -maxdepth 1 -type f -name "cheat.zsh" -exec cp {} "${ZSH_COMPLETIONS}/" \;

COPY config/cheat/cheatsheets "${HOME}/.config/cheat/cheatsheets"

###############################################################################
# Install and configure powerlevel10k
###############################################################################

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
RUN ${ZSH_CUSTOM}/themes/powerlevel10k/gitstatus/install

COPY --chown=${USER_ID}:${GROUP_ID} config/powerlevel10k/.p10k.zsh "${HOME}/.p10k.zsh"

###############################################################################
# Install and configure tmux
###############################################################################

COPY --chown=${USER_ID}:${GROUP_ID} config/tmux/.tmux.conf ${HOME}/.tmux.conf
RUN export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
  && git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm \
  &&  $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins

COPY --chown=${USER_ID}:${GROUP_ID} config/python/.pylintrc ${HOME}/.pylintrc
COPY --chown=${USER_ID}:${GROUP_ID} config/zsh/.zshrc ${HOME}/.zshrc

COPY scripts/splashScreen.sh /opt/splashScreen.sh
COPY scripts/getscrumupdates.sh /opt/getscrumupdates.sh
COPY scripts/checkcolors.sh /opt/checkcolors.sh

COPY config/fortune/quotes /opt/fortune/quotes
COPY config/fortune/quotes.dat /opt/fortune/quotes.dat

###############################################################################
# Install and configure NodeJS
###############################################################################

RUN sudo apt-get install -y \
  nodejs \
  npm

RUN mkdir "${HOME}/.npm-global"
RUN npm config set prefix "${HOME}/.npm-global"
ENV PATH="${HOME}/.npm-global/bin:${PATH}"
RUN npm install --global yarn
ENV PATH="${HOME}/.yarn/bin:${PATH}"

RUN yarn global add vscode-html-languageserver-bin \
  && yarn global add -D lehre \
  && yarn global add neovim \
  && yarn global add typescript \
  && yarn global add tldr  

###############################################################################
# Initialize tldr
###############################################################################

RUN tldr -u

