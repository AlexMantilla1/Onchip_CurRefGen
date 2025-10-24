#!/bin/bash
# This script should be sourced: . setup_glayout.sh
# Unset (clear) the variable
unset PYTHONPATH

# === Step 1: Define environment variables ===
# These must match your installation script
export BASE_DIR="$HOME/conda-env"
export MINICONDA_DIR="$BASE_DIR/miniconda3"
export ENV_NAME="GLdev"

export PATH="$MINICONDA_DIR/bin:$PATH"

# === Step 2: Initialize Conda for the current shell ===
# This is the crucial missing step. It loads the conda functions.
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# === Step 3: Activate the environment ===
conda activate "$ENV_NAME"
