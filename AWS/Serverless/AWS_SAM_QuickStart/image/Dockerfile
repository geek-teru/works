FROM amazonlinux:latest

RUN yum -y install unzip git && \
    python3 -m ensurepip --upgrade && \
    curl -L -o aws-sam-cli-linux-arm64.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && \
    unzip aws-sam-cli-linux-arm64.zip -d sam-installation && \
    ./sam-installation/install

RUN rm -rf aws-sam-cli-linux-arm64.zip sam-installation/