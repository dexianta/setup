FROM ubuntu:focal

RUN apt-get update
RUN apt-get install -y build-essential curl git ansible neovim sudo

RUN useradd -create-home -s /bin/bash -G sudo dockeruser
RUN echo "dockeruser:pass" | sudo chpasswd

USER dockeruser 
WORKDIR /home/dockeruser

COPY . .
