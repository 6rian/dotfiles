#!/bin/bash

 sudo apt update -y
 sudo apt upgrade -y

 sudo timedatectl set-timezone America/New_York

 sudo apt install -y \
  curl \
  gcc \
  git \
  grc \
  fzf \
  htop \
  jq \
  make \
  net-tools \
  nmap \
  ripgrep \
  tmux \
  unzip \
  vim \
  wget \
  xclip \
  zsh

 # download and install neovim prebuilt binary to get the latest version

 # loop through programs, make each executable and run it
