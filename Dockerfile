FROM ubuntu:20.04

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
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        jq \
        less \
        locales \
        ncdu \
        neovim \
        python3-pip \
        ruby \
        screenfetch \
        software-properties-common \
        ssh-client \
        sudo \
        tmux \
        zsh \
    && apt-get clean

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# update / install sources
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    touch /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        kubectl \
        nodejs \
    && apt-get clean

ENV PATH="$PATH:$(which node)"

# add binaries for docker cli and yarn
ENV DOCKERVERSION=18.03.1-ce
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz \
  && curl -o- -L https://yarnpkg.com/install.sh | bash \
  && pip3 install pynvim \
  && git clone --depth 1 https://github.com/junegunn/fzf.git /usr/local/.fzf && /usr/local/.fzf/install \
  && gem instal tmuxinator \
  && curl https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -o /usr/local/share/zsh/site-functions/_tmuxinator


# install coc extensions
WORKDIR ${HOME}/.config/coc/extensions

COPY config/coc/package.json .
RUN ${HOME}/.yarn/bin/yarn --ignore-scripts --no-lockfile

# remove all global node modules
RUN npm ls -gp --depth=0 | awk -F/node_modules/ '{print $2}' | grep -vE '^(npm|)$' | xargs -r npm -g rm

WORKDIR ${HOME}

# install vim-plug
RUN curl -fLo ${HOME}/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY config/nvim/init.vim ${HOME}/.config/nvim/init.vim
RUN nvim --headless +PlugInstall +qall

# install and configure oh-my-zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions
COPY config/zsh/.zshrc ${HOME}/.zshrc

# install and configure powerlevel10k
COPY config/powerlevel10k/.p10k.zsh ${HOME}/.p10k.zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/powerlevel10k \
    && /usr/local/powerlevel10k/gitstatus/install

# install and configure tmux plugin manager
COPY config/tmux/.tmux.conf $HOME
ENV TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins/tpm"
RUN git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm \
    && ${HOME}/.tmux/plugins/tpm/bin/install_plugins

RUN groupadd workbench && \
    useradd ${USER_NAME} --shell /bin/zsh -g workbench && \
    chown -R ${USER_NAME}: ${HOME} && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

COPY scripts/entrypoint.sh /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]
