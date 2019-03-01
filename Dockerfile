FROM debian:stretch
ENV TERM xterm

RUN apt-get --yes update && \
  apt-get --yes upgrade

RUN apt-get --yes install curl software-properties-common gnupg git-core locales sudo zsh openssh-server apt-utils \
  iputils-ping vim wget cron screen unzip

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get --yes install nodejs

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

RUN locale-gen en_US.UTF-8

RUN ( mkdir /var/run/sshd ;\
      sed -i "/PermitRootLogin/s/#Permit/Permit/" /etc/ssh/sshd_config ;\
      sed -i "/PermitRootLogin/s/prohibit-password/yes/" /etc/ssh/sshd_config ;\
      sed -i "s/UsePAM yes/#UsePAM yes/g" /etc/ssh/sshd_config ;\
      sed -i "s/#Port 22/Port 6000/" /etc/ssh/sshd_config )

RUN ( echo 'root:debian' | chpasswd )

WORKDIR /root

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN curl -OL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

RUN bash install.sh && rm -rf install.sh

RUN echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> .zshrc

RUN mkdir .ssh && \
  chmod 0600 .ssh

RUN curl -L https://github.com/hasura/graphql-engine/raw/master/cli/get.sh | bash

RUN .yarn/bin/yarn global add lerna firebase-tools
RUN .yarn/bin/yarn global add @google-cloud/functions-emulator --ignore-engines

EXPOSE 6000

CMD ["/usr/sbin/sshd", "-D"]
