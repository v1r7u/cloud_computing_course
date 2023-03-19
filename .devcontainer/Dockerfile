FROM ubuntu:focal-20220404

RUN apt-get -y update
RUN apt-get -y install \
    unzip \
    curl \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
    git

### AZ CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get -y update
RUN apt-get -y install azure-cli

### AZ FUNC
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/dotnetdev.list
RUN apt-get -y update
RUN apt-get -y install \
    python3-venv \
    azure-functions-core-tools-3

# Without this env variable, `func` fails to run any command.
# More details: https://github.com/Azure/azure-functions-core-tools/issues/2554
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

ARG TERRAFORM_VERSION=1.4.2
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform version

ARG KUBECTL_VERSION=1.23.6
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin/ && \
    chmod a+x /usr/local/bin/kubectl && \
    kubectl version --client
