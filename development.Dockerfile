FROM mcr.microsoft.com/devcontainers/base:bullseye
ARG TARGETARCH

WORKDIR /usr/local

## Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    software-properties-common \
    curl \
    && rm -rf /var/lib/apt/lists/*

## Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

## Install Terraform
RUN curl -sSL https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y --no-install-recommends terraform \
    && rm -rf /var/lib/apt/lists/*

## Install OpenTofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
    && chmod +x install-opentofu.sh \
    && ./install-opentofu.sh --install-method deb \
    && rm install-opentofu.sh

## Install Hadolint
RUN curl -sSL -o hadolint "https://github.com/hadolint/hadolint/releases/download/v2.7.0/hadolint-Linux-x86_64" && \
    chmod +x hadolint && \
    mv hadolint bin/

## Install TFLint
RUN curl -sSL -o tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v0.31.0/tflint_linux_amd64.zip" && \
    unzip tflint.zip && \
    rm tflint.zip && \
    chmod +x tflint && \
    mv tflint bin/

## Installing Go
# Set a build argument for the architecture
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV GOLANG_VERSION=1.22.3
ENV PATH $GOROOT/bin:/usr/local/go/bin:$PATH
RUN curl -sSl -L -o go.tar.gz "https://go.dev/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz" && \ 
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz && \
    mkdir $GOPATH

## Install Akamai CLI
ENV AKAMAI_CLI_HOME=/cli
RUN git clone https://github.com/akamai/cli.git /cli && \
    go -C /cli build -o /usr/bin/akamai cli/main.go && \
    mkdir -m 777 $AKAMAI_CLI_HOME/.akamai-cli && \
    akamai install edgeworkers && \
    akamai install property-manager && \
    chmod -R 777 $AKAMAI_CLI_HOME

## Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
