#!/bin/bash


function log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

function log_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

function log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

function log_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

function executable_exists() {
    command -v "$1" >/dev/null 2>&1
}

function assert_executable_exists() {
    if ! executable_exists "$1"; then
        log_error "Required executable '$1' not found. Please install it and try again."
        exit 1
    fi
}

###############################################################################
# Install xcode command line tools if not installed, like git.
###############################################################################
if ! executable_exists "xcode-select"; then
    log_info "Installing Xcode Command Line Tools"
    xcode-select --install

    assert_executable_exists "xcode-select"
    log_success "Xcode Command Line Tools installed successfully."
else
    log_info "Xcode Command Line Tools already installed."
fi

###############################################################################
# Ensure git is installed
###############################################################################
assert_executable_exists "git"
log_success "Git is installed at: $(which git)"

###############################################################################
# Clone dotfiles repo
# TODO: Certs setup first?
###############################################################################
# git clone git@github.com:6rian/dotfiles.git ~/repos/dotfiles

###############################################################################
# Install package manager: Homebrew
###############################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
assert_executable_exists "brew"
log_success "Homebrew is installed at: $(which brew)"

###############################################################################
# Install ansible
###############################################################################
brew install ansible
assert_executable_exists "ansible"
log_success "Ansible is installed at: $(which ansible)"

###############################################################################
# DONE
###############################################################################
log_success "Bootstrap for macOS completed successfully."
log_success "You can now run ...TODO... to install your dotfiles and applications."
