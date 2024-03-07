# Use ubuntu:latest as the base image for amd64 architecture
FROM ubuntu:latest

# Set architecture
ENV ARCH=amd64
ENV ARCHX=x64

# Update and upgrade package lists
RUN DEBIAN_FRONTEND=noninteractive apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get install -y -qq --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        apt-utils \
        iputils-ping \
        curl \
        file \
        git \
        gnupg \
        gnupg-agent \
        locales \
        sudo \
        time \
        unzip \
        wget \
        zip \
        jq \
        netcat \
        software-properties-common \
        build-essential \
        python3 \
        python3-pip \
        dnsutils \
        iputils-ping \
        openssl \
        net-tools \
        lld \
        libcurl4 \
        libxss1 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libatspi2.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libgbm1 \
        libxkbcommon0 \
        libpango-1.0-0 \
        libcairo2 \
        libatk1.0-0 \
        default-jdk

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
&& apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install Maven & hold jdk version.
RUN apt-mark hold default-jdk && \
    apt-get install -y maven 
ARG USER_HOME_DIR="/root"
ARG GRADLE_VERSION=8.6
# Define variable.
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${PATH}:/usr/local/gradle/bin"
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# Gradle installation
RUN wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip  \
 && unzip -q gradle-$GRADLE_VERSION-bin.zip \
 && rm gradle-$GRADLE_VERSION-bin.zip \
 && mv gradle-$GRADLE_VERSION /usr/local/gradle
ENV GRADLE_HOME=/usr/local/gradle

# Install .NET LTS
ENV DOTNET_ROOT="/etc/.dotnet"
RUN curl -Lo dotnet-install.sh https://dot.net/v1/dotnet-install.sh
RUN chmod +x ./dotnet-install.sh && ./dotnet-install.sh --install-dir ${DOTNET_ROOT} --channel LTS --version latest \
    && rm -rf /dotnet-install.sh
ENV PATH="${PATH}:${DOTNET_ROOT}:${DOTNET_ROOT}/tools"

# Helm installation
RUN wget https://baltocdn.com/helm/signing.asc \
 && apt-key add signing.asc \
 && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
 && apt-get update \
 && apt-get install -y helm
# Set environment variable for Helm home
ENV HELM_HOME /helm 

# Install Docker & Buildx
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/3.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install Azure CLI
RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash

# Install az extensions
RUN az extension add --name managementpartner

# Install azd
RUN curl -fsSL https://aka.ms/install-azd.sh | bash -s -- -a ${ARCH}

# Install bicep
RUN curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-${ARCHX} \
&& chmod a+x ./bicep \
&& mv ./bicep /usr/local/bin/bicep

#  Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && apt install terraform

# Install PowerShell core (latest)
RUN response=$(curl -s -L -I -o /dev/null -w '%{url_effective}' https://github.com/PowerShell/PowerShell/releases/latest) \
    && PSLatestVersion=$(basename "$response" | tr -d 'v') \
    && curl -Lo powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v$PSLatestVersion/powershell-$PSLatestVersion-linux-${ARCHX}.tar.gz" \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && chmod +x /opt/microsoft/powershell/7/pwsh \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && rm -rf /powershell.tar.gz

# Install poweshell modules
RUN pwsh -c 'Install-Module -Name Az -Scope AllUsers -Force'

ENV CHROME_DIR /opt/google
RUN mkdir -p $CHROME_DIR
RUN wget -q --continue -P $CHROME_DIR "https://storage.googleapis.com/chrome-for-testing-public/122.0.6261.94/linux64/chrome-linux64.zip"
RUN unzip $CHROME_DIR/chrome-l* -d $CHROME_DIR && \
    chmod +x $CHROME_DIR/chrome-linux64/chrome
# Download and install Chromedriver
RUN wget -q --continue -P $CHROME_DIR "https://storage.googleapis.com/chrome-for-testing-public/122.0.6261.94/linux64/chromedriver-linux64.zip"
RUN unzip $CHROME_DIR/chromedriver* -d $CHROME_DIR && \
    chmod +x $CHROME_DIR/chromedriver-linux64/chromedriver
RUN wget -q --continue -P $CHROME_DIR "https://storage.googleapis.com/chrome-for-testing-public/122.0.6261.94/linux64/chrome-headless-shell-linux64.zip"
RUN unzip $CHROME_DIR/chrome-headless* -d $CHROME_DIR && \
    chmod +x $CHROME_DIR/chrome-headless-shell-linux64/chrome-headless-shell
# Put Chrome executables into the PATH
ENV PATH /opt/google/chrome-linux64:$PATH
ENV PATH /opt/google/chromedriver-linux64:$PATH
ENV PATH /opt/google/chrome-headless-shell-linux64:$PATH

# Clean apt-get installation packages
RUN rm -rf /var/lib/apt/lists/* && apt-get clean

# # Set locale
# RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     locale-gen

# # Set the default shell to bash for interactive terminals
# ENV SHELL /bin/bash

# # Set the entrypoint
# CMD ["sleep", "infinity"]


