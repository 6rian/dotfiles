#!/bin/bash

 sudo apt update -y
 sudo apt upgrade -y

 sudo timedatectl set-timezone America/New_York

 sudo apt install -y curl \
  git \
  tmux \
  vim \
  htop \
  grc \
  jq \
  net-tools