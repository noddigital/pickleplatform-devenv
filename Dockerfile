FROM debian:stretch
ENV TERM xterm

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update \
    && apt-get install -y curl software-properties-common gnupg git-core locales sudo zsh apt-utils \
  iputils-ping vim wget cron screen unzip build-essential apt-transport-https \
    && apt-get -y autoclean

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.1

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ENV LANG="en_US.UTF-8"
RUN locale-gen en_US.UTF-8

WORKDIR /root

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -yq \
        yarn --no-install-recommends \
    && apt-get clean -yq \
    && rm -rf /var/cache/apt/*

# ZSH
RUN curl -OL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
RUN bash install.sh && rm -rf install.sh

# Hasura
RUN curl -L https://github.com/hasura/graphql-engine/raw/master/cli/get.sh | bash

RUN yarn global add lerna babel-cli

EXPOSE 6000
