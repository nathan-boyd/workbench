FROM ubuntu:20.04

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
        autojump \
        ca-certificates \
        cowsay \
        ctop \
        curl \
        git \
        gnupg-agent \
        htop \
        httpie \
        jq \
        less \
        locales \
        mtr \
        ncdu \
        neovim \
        python3-pip \
        ripgrep \
        ruby \
        screenfetch \
        software-properties-common \
        ssh-client \
        sudo \
        tmux \
        tree \
        wget \
        zsh \
    && apt-get clean

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# update / install apt sources
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    touch /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        kubectl \
        nodejs \
    && apt-get clean

ENV PATH="$PATH:/usr/bin/node"

# add binaries
RUN \
  export DOCKERVERSION=18.03.1-ce \
    && curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz" \
    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
    && rm docker-${DOCKERVERSION}.tgz \
  && git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/.fzf && /usr/local/.fzf/install \
  && gem instal tmuxinator \
  && curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
    -o /usr/local/share/zsh/site-functions/_tmuxinator \
  && export GO_VERSION=1.14.2 \
    && curl "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o - | tar -xz -C /usr/local \
  && curl https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz  -o- -L | tar -xz -C /usr/local/bin/ \
  && pip3 install pynvim \
  && pip3 install git+https://github.com/jeffkaufman/icdiff.git \
  && export BAT_VERSION="0.15.4" \
    && wget "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb" \
    && dpkg -i "bat_${BAT_VERSION}_amd64.deb" \
    && rm "bat_${BAT_VERSION}_amd64.deb" \
  && curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64 \
    && chmod 755 /usr/local/bin/gomplate

# install coc extensions
WORKDIR ${HOME}/.config/coc/extensions

COPY config/coc/package.json .
RUN /usr/bin/npm install --ignore-scripts --no-lockfile
# remove all global node modules
RUN npm ls -gp --depth=0 | awk -F/node_modules/ '{print $2}' | grep -vE '^(npm|)$' | xargs -r npm -g rm

WORKDIR ${HOME}

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

# install and configure tmux and nvim plugins
COPY config/tmux/.tmux.conf ${HOME}/.tmux.conf
COPY config/nvim/init.vim ${HOME}/.config/nvim/init.vim
RUN export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
    && git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm \
    &&  $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins \
    && nvim --headless +PlugInstall +qall

# create user to run under
RUN groupadd workbench && \
    useradd ${USER_NAME} --shell /bin/zsh -g workbench && \
    chown -R ${USER_NAME}: ${HOME} && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

COPY config/tmuxinator/template.tpl /opt/tmuxinator/template.tpl
COPY config/zsh/.zshrc ${HOME}/.zshrc
COPY config/git/.gitconfig ${HOME}/.gitconfig
COPY config/coc/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
COPY scripts/entrypoint.sh /opt/entrypoint.sh
COPY scripts/splashScreen.sh /opt/splashScreen.sh
COPY scripts/workbenchStop.sh /opt/workbenchStop.sh

CMD ["/opt/entrypoint.sh"]
