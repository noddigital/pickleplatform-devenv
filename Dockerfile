FROM debian:stretch
ENV TERM xterm

RUN apt-get --yes update && \
  apt-get --yes upgrade

RUN apt-get --yes install curl software-properties-common gnupg git-core locales sudo zsh apt-utils \
  iputils-ping vim wget cron screen unzip

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get --yes install nodejs

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

RUN locale-gen en_US.UTF-8

WORKDIR /root

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN curl -OL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

RUN bash install.sh && rm -rf install.sh

RUN echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> .zshrc

RUN curl -L https://github.com/hasura/graphql-engine/raw/master/cli/get.sh | bash

RUN .yarn/bin/yarn global add lerna firebase-tools babel-cli
RUN .yarn/bin/yarn global add @google-cloud/functions-emulator --ignore-engines

RUN echo 'alias hasura-console="hasura console --address 0.0.0.0 --no-browser"' >> .zshrc
EXPOSE 6000
