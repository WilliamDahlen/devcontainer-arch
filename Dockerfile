FROM archlinux:base

LABEL maintainer="william@dahlen.dev"
ENV TZ Europe/OSLO
RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm \
    git \
    zsh \
    wget \
    unzip \
    sudo \
    go

RUN wget https://github.com/Jguer/yay/releases/download/v11.2.0/yay_11.2.0_x86_64.tar.gz
RUN tar -xf yay_11.2.0_x86_64.tar.gz
RUN cp yay_11.2.0_x86_64/yay /usr/local/bin/yay
RUN rm yay_11.2.0_x86_64.tar.gz && rm -rf yay_11.2.0_x86_64

ENV USER_NAME cznk

RUN useradd --shell /bin/zsh --create-home $USER_NAME
RUN echo "${USER_NAME}" | usermod -aG wheel $USER_NAME
RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME && chmod 0440 /etc/sudoers.d/$USER_NAME

ENV HOME /home/$USER_NAME

USER $USER_NAME:$USER_NAME



ENV TERM xterm

ENV SHELL /bin/zsh

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

RUN cd $HOME && curl -fsSLO https://raw.githubusercontent.com/romkatv/dotfiles-public/master/.purepower

ADD .zshrc $HOME
ADD .p10k.zsh $HOME
RUN sudo chown $USER_NAME:$USER_NAME /home/$USER_NAME/.zshrc
RUN sudo chown $USER_NAME:$USER_NAME /home/$USER_NAME/.p10k.zsh
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install

WORKDIR /home/$USER_NAME

CMD [ "/bin/zsh" ]
