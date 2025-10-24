#!/bin/bash
set -e  # Exit on error

# === Step 1: Basic environment setup ===
unset PYTHONPATH
unset LD_LIBRARY_PATH

# Define base directory for conda installation and environment name
BASE_DIR="$HOME/conda-env"
MINICONDA_DIR="$BASE_DIR/miniconda3"
ENV_NAME="GLdev"

export PATH="$MINICONDA_DIR/bin:$PATH"

# === Step 2: Check if environment is already set up ===
if [ -d "$MINICONDA_DIR/envs/$ENV_NAME" ]; then
    echo "'$ENV_NAME' environment already exists. Nothing to do."
    echo "To use it, open a new terminal and run: conda activate $ENV_NAME"
else
    echo "'$ENV_NAME' environment not found. Starting setup..."

    # Create base directory
    mkdir -p "$BASE_DIR"
    cd "$BASE_DIR"

    # Download and install Miniconda
    echo "Downloading Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-`uname -i`.sh -O miniconda.sh
    bash miniconda.sh -b -p "$MINICONDA_DIR"

    # Source Conda to make the 'conda' command available
    source "$MINICONDA_DIR/etc/profile.d/conda.sh"

    # Create the conda environment with Python 3.10
    echo "Creating '$ENV_NAME' environment with Python 3.10..."
    conda create -y -n "$ENV_NAME" python=3.10

    # Activate the environment to install packages into it
    conda activate "$ENV_NAME"

    # Install packages with Conda
    echo "Installing Conda packages (numpy, matplotlib, etc.)..."
    conda install -y jupyter jupyterlab notebook nbclassic \
        jupyter_server_ydoc jupyter_server_fileid \
        numpy=1.24 matplotlib pip \
        -c litex-hub -c conda-forge -c anaconda

    # Register the kernel (good practice for VS Code to find it)
    python -m ipykernel install --user --name="$ENV_NAME"

    # Pip packages
    echo "Installing Pip packages (glayout, klayout)..."
    pip install glayout
    pip install "klayout>=0.28,<0.29"
    pip install svgutils

    echo "O Setup complete! '$ENV_NAME' is ready."
    echo "To use it, open a new terminal and run: conda activate $ENV_NAME"

    conda deactivate
fi
