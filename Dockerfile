FROM ubuntu:20.04
# basic packages
RUN apt-get update && apt-get install -y wget xz-utils unzip curl git
# node
ENV NODE_VERSION=v14.17.5
WORKDIR /root
RUN wget https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz
RUN mkdir -p /usr/local/lib/nodejs
RUN tar -xJvf node-$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs 
RUN rm node-$NODE_VERSION-linux-x64.tar.xz
ENV PATH=/usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64/bin:$PATH
RUN npm i -g yarn
# docker-cli
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli
# aws-cli
RUN mkdir -p aws && \
    cd aws && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cd . && rm -rf aws
# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# v2ray
RUN mkdir -p /usr/local/v2ray
ENV VERSION 4.34.0
WORKDIR /usr/local/v2ray
RUN wget -q https://github.com/v2fly/v2ray-core/releases/download/v${VERSION}/v2ray-linux-64.zip \
    && unzip v2ray-linux-64.zip \
    && chmod +x v2ray v2ctl \
    && rm *.zip
WORKDIR /root
COPY proxy.sh /root/proxy.sh
RUN chmod +x /root/proxy.sh
COPY unset_proxy.sh /root/unset_proxy.sh
RUN chmod +x /root/unset_proxy.sh
# proxy-chains
RUN apt-get update && apt-get install -y proxychains-ng
