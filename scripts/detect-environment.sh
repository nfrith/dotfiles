#!/bin/bash

# Function to detect if we're in a remote/container environment
is_remote_environment() {
    # Check for DevPod environment variables
    if [[ -n "${DEVPOD}" || -n "${DEVPOD_WORKSPACE_ID}" ]]; then
        return 0
    fi
    
    # Check for container indicators
    if [[ -n "${CONTAINER}" || -f /.dockerenv ]]; then
        return 0
    fi
    
    # Check for common CI environments
    if [[ -n "${CI}" || -n "${GITHUB_ACTIONS}" || -n "${GITLAB_CI}" ]]; then
        return 0
    fi
    
    # Check if we're in a Codespace
    if [[ -n "${CODESPACES}" ]]; then
        return 0
    fi
    
    # Check for SSH connection (might be remote)
    if [[ -n "${SSH_CONNECTION}" || -n "${SSH_CLIENT}" ]]; then
        return 0
    fi
    
    return 1
}

# Function to detect macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Function to detect Linux
is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

# Export functions for use in other scripts
export -f is_remote_environment is_macos is_linux