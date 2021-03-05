FROM ubuntu

ENV COLUMNS=80
ENV VAULT_VERSION=1.2.2

# COLUMNS var added to work around bosh cli needing a terminal size specified

# base packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -yy wget gnupg \
    && wget -q -O - https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add - \
    && echo "deb http://apt.starkandwayne.com stable main" | tee /etc/apt/sources.list.d/starkandwayne.list \
    && wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -yy \
      autoconf \
      bosh-cli \
      build-essential \
      bzip2 \
      certstrap \
    #   cf-cli \
    #   cf6-cli \
      concourse-fly \
      credhub-cli \
      curl \
      genesis \
      git \
      gotcha \
      hub \
      file \
      jq \
      kubectl \
      libreadline8 \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libtool \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      lsof \
      om \
      openssl \
      pivnet-cli \
      ruby \
      ruby-dev \
      safe \
      sipcalc \
      spruce \
      sqlite3 \
      vim-common \
      wget \
      unzip \
      zlib1g-dev \
      zlibc \
    && rm -rf /var/lib/apt/lists/*


# Install Cloud Foundry cli v6
ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.53.0 /tmp/cf-cli.tgz
RUN mkdir -p /usr/local/bin && \
  tar -xf /tmp/cf-cli.tgz -C /usr/local/bin && \
  cf --version && \
  rm -f /tmp/cf-cli.tgz

# Install Cloud Foundry cli v7
# ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=7.2.0 /tmp/cf7-cli.tgz
# RUN mkdir -p /usr/local/bin /tmp/cf7-cli && \
#   tar -xf /tmp/cf7-cli.tgz -C /tmp/cf7-cli && \
#   install /tmp/cf7-cli/cf7 /usr/local/bin/cf7 && \
#   cf7 --version && \
#   rm -f /tmp/cf7-cli.tgz && \
#   rm -rf /tmp/cf7-cli

RUN curl -Lo vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip vault.zip \
    && mv vault /usr/bin/vault \
    && chmod 0755 /usr/bin/vault \
    && rm vault.zip

# Install git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install git-lfs && \
    git lfs install

# Install Hugo
RUN curl -L >hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.36/hugo_0.36_Linux-64bit.tar.gz \
 && tar -xzvf hugo.tar.gz -C /usr/bin \
 && rm hugo.tar.gz

# Rubygems
RUN gem install cf-uaac fpm deb-s3 --no-document

# Add a user for running things as non-superuser
RUN useradd -ms /bin/bash worker

# Install yq cli
ADD https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 /tmp/yq_linux_amd64
RUN install /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  yq --version && \
  rm -f /tmp/yq_linux_amd64


ADD resource/ /opt/resource/
RUN chmod +x /opt/resource/*

WORKDIR /
ENTRYPOINT ["/bin/bash"]