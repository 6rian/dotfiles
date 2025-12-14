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

