# Use ubuntu:22.04 as the base image for amd64 architecture
FROM selfhostedcontainerimages009.azurecr.io/baseimage:latest

# Set architecture
ENV ARCHX=x64
# Set additional environment variables
ENV AGENT_VERSION=${AGENT_VERSION:-3.220.0}
LABEL agent_version=$AGENT_VERSION

# Copy the .env file into the Docker image
COPY .env /.env

# Read variables from .env file and set them as build arguments
ARG NAME
ARG AZP_URL
ARG AZP_POOL

# Set environment variables using build arguments
ENV AZP_URL=$AZP_URL
ENV NAME=$NAME
ENV AZP_POOL=$AZP_POOL

WORKDIR /myagent/

# Download the Agent
RUN curl -LSs "https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${ARCHX}-${AGENT_VERSION}.tar.gz" | tar -xz

RUN adduser --disabled-password agent \
    && usermod -aG sudo agent \
    && chown -R agent /myagent \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

COPY ./start.sh ./
RUN chmod +x ./start.sh

USER agent

ENTRYPOINT ["./start.sh"]