# Use multi-stage builds
FROM debian:bullseye-slim as builder
ARG TARGETARCH

WORKDIR /usr/local

ENV GOROOT=/usr/local/go \
GOPATH=$HOME/go \
GOLANG_VERSION=1.22.3 \
PATH=/usr/local/go/bin:/usr/local/go/bin:$PATH \
AKAMAI_CLI_HOME=/cli

# Install dependencies, Node.js, Terraform, OpenTofu, Hadolint, TFLint, Go, Akamai CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    software-properties-common \
    curl \
    unzip \
    git \
    jq \
    chromium \
    ca-certificates \
    # Puppeteer dependencies
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    ssh \
    vim \
    xdg-utils \   
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && curl -sSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends terraform \
    && curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \
    && chmod +x install-opentofu.sh \
    && ./install-opentofu.sh --install-method deb \
    && rm install-opentofu.sh \
    && curl -sSL -o hadolint "https://github.com/hadolint/hadolint/releases/download/v2.7.0/hadolint-Linux-x86_64" \
    && chmod +x hadolint \
    && mv hadolint /usr/local/bin/ \
    && curl -sSL -o tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v0.31.0/tflint_linux_amd64.zip" \
    && unzip tflint.zip \
    && chmod +x tflint \
    && mv tflint /usr/local/bin/ \
    && rm tflint.zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install GO
RUN curl -sSl -L -o go.tar.gz "https://go.dev/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz" \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz \
    && mkdir $GOPATH

# Install Akamai CLI
RUN git clone --depth 1 https://github.com/akamai/cli.git /cli \
    && go -C /cli build -o /usr/bin/akamai cli/main.go \
    && mkdir -m 777 $AKAMAI_CLI_HOME/.akamai-cli \
    && akamai install edgeworkers \
    && akamai install property-manager \
    && chmod -R 777 $AKAMAI_CLI_HOME \
    && rm -rf /cli/.git

# Final stage
FROM debian:bullseye-slim
ARG TARGETARCH

COPY --from=builder /usr/local /usr/local
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /lib/ /lib
COPY --from=builder /etc/ssl /etc/ssl
COPY --from=builder /cli /cli
COPY --from=builder /etc/chromium.d /etc/chromium.d
# Assuming shared resources for Chromium might be here
COPY --from=builder /usr/share /usr/share  
COPY --from=builder /etc/alternatives/vim /etc/alternatives/vim
# Installing Go
ENV GOROOT=/usr/local/go \
    GOPATH=$HOME/go \
    PATH=$GOROOT/bin:/usr/local/go/bin:$PATH \
    AKAMAI_CLI_HOME=/cli \ 
    PUPPETEER_EXECUTABLE_PATH='/usr/bin/chromium' \
    TARGETARCH=${TARGETARCH} \
    LD_LIBRARY_PATH=/lib/linux/gnu:$LD_LIBRARY_PATH


# Add vscode user and group, and create the /etc/chromium.d/ directory in the final image
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode \
    && mkdir -p /etc/chromium.d/ \
    && chown -R vscode:vscode /etc/chromium.d/

# Ensure the vscode user can run Chromium without sandbox or with appropriate flags
# Note: Adjusting the Puppeteer launch script to include '--no-sandbox' flag is recommended for Docker environments