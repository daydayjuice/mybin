#!/bin/bash

# Check if parameters are provided
APPENDIX=$1
ACTION=$2

# Set variables
if [ -n "$APPENDIX" ]; then
    KUBECONFIG_PATH="$HOME/.kube/config.${APPENDIX}"
else
    KUBECONFIG_PATH="$HOME/.kube/config"
fi
BACKUP_DIR="$HOME/.kube/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Set backup file name based on appendix
if [ -n "$APPENDIX" ]; then
    BACKUP_FILE="config.${APPENDIX}_${TIMESTAMP}"
    FIND_PATTERN="config.${APPENDIX}_*"
else
    BACKUP_FILE="config_${TIMESTAMP}"
    FIND_PATTERN="config_*"
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if file exists
if [ ! -f "$KUBECONFIG_PATH" ]; then
    echo "Error: Kubeconfig file not found at $KUBECONFIG_PATH"
    exit 1
fi

# Handle file based on ACTION parameter
if [ "$ACTION" = "new" ]; then
    # Create new backup copy
    cp "$KUBECONFIG_PATH" "$BACKUP_DIR/$BACKUP_FILE"
    echo "Kubeconfig backup created: $BACKUP_FILE"
    export KUBECONFIG="$BACKUP_DIR/$BACKUP_FILE"
    echo "KUBECONFIG environment variable set to: $KUBECONFIG"
else
    # Use original file
    export KUBECONFIG="$KUBECONFIG_PATH"
    echo "KUBECONFIG environment variable set to original file: $KUBECONFIG"
fi

# Remove files older than 1 day with matching pattern
find "$BACKUP_DIR" -name "$FIND_PATTERN" -type f -mtime +7 -exec rm {} \;
echo "Removed backup files older than 7 day"

# export KUBECONFIG=~/.kube/config.nt2; export AWS_CONFIG_FILE=~/.aws/config.nt2; export GIT_CONFIG_GLOBAL=~/.git/config.nt2; bastionstg=i-0c2624b5efccfbde2
