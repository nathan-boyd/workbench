FROM ubuntu:20.04

ENV USER_NAME me
ENV HOME /home/${USER_NAME}

WORKDIR ${HOME}

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
        ca-certificates \
        git \
        curl \
        tmux \
        zsh \
        fzf \
        neovim \
        sudo \
        gnupg-agent \
        software-properties-common

# add docker cli
ENV DOCKERVERSION=18.03.1-ce
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    touch /etc/apt/sources.list.d/kubernetes.list && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends kubectl

# install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y --no-install-recommends nodejs && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# install coc extensions
WORKDIR ${HOME}/.config/coc/extensions

COPY config/coc/package.json .
RUN ${HOME}/.yarn/bin/yarn --ignore-scripts --no-lockfile

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
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/powerlevel10k
RUN echo "source /usr/local/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
COPY config/powerlevel10k/.p10k.zsh ${HOME}/.p10k.zsh

# install and configure tmux
ENV TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins/tpm"
COPY config/tmux/.tmux.conf ${HOME}/.tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm && \
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins

RUN groupadd workbench && \
    useradd ${USER_NAME} --shell /bin/zsh -g workbench && \
    chown -R ${USER_NAME}: ${HOME} && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USER_NAME}

COPY scripts/entrypoint.sh /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]
