#!/bin/bash

enable_strict_mode() {
    set -e  # Exit immediately if a command exits with a non-zero status
    set -u  # Treat unset variables as an error
    set -o pipefail  # Catch errors in pipelines
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

check_success() {
    if ! "$@"; then
        error_exit "Failed to execute: $*"
    fi
}