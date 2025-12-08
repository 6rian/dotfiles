#!/bin/bash

source ./scripts/utils.sh

# Install xcode command line tool if not installed
if ! executable_exists "xcode-select"; then
    log_info "Installing Xcode Command Line Tools"
    xcode-select --install

    assert_executable "xcode-select"
    log_success "Xcode Command Line Tools installed successfully."
else
    log_info "Xcode Command Line Tools already installed."
fi

# python3 and pip3 are required
assert_executable "python3"
log_info "Python3 is installed at: $(which python3)"
assert_executable "pip3"
log_info "pip3 is installed at: $(which pip3)"

