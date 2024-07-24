#!/bin/bash

# This script installs all the tools needed for the scripts in this repository
# on Compute Canada. It installs the following tools in the directories 
# specified in the config file you provide as an argument.
#

# To run this script cd into the repo's directory and use :
# bash /home/ludoal/scratch/ChronicPainDWI/utils/install_tools_cc.sh your_config.sh
# 
# What gets installed :
        # 1. scilus_1.6.0.sif
        # - Downloaded and moved to the specified containers directory.

        # 2. tractoflow
        # - Cloned from https://github.com/scilus/tractoflow.git.

        # 3. dmriqc_flow
        # - Cloned from https://github.com/scilus/dmriqc_flow.git.

        # 4. rbx_flow
        # - Cloned from https://github.com/scilus/rbx_flow.git.

        # 5. combine_flows
        # - Cloned from https://github.com/scilus/combine_flows.git.

        # 6. tractometry_flow
        # - Cloned from https://github.com/scilus/tractometry_flow.git.

        # 7. Atlas files for bundleseg
        # - Downloaded from https://zenodo.org/record/10103446 and extracted to the atlas directory.

# Function to display the help message


# Function to check and create directory if it doesn't exist
check_and_create_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo "Directory '$dir' does not exist. Creating it..."
        mkdir -p "$dir" || { echo "Failed to create directory '$dir'. Exiting..."; exit 1; }
    else
        echo "Directory '$dir' exists."
    fi
}


# Function to download and move .sif file
download_sif() {
    local dir="$1/containers"
    check_and_create_directory "$dir"
    local sif_file="$dir/scilus_1.6.0.sif"
    if [ ! -f "$sif_file" ]; then
        echo "Downloading scilus_1.6.0.sif..."
        wget https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif -P "$dir" || { echo "Failed to download scilus_1.6.0.sif. Exiting..."; exit 1; }
    else
        echo "scilus_1.6.0.sif is already installed."
    fi
}

# Function to clone repository if not already cloned
clone_repo() {
    local repo_url="$1"
    local target_dir="$2"
    if [ ! -d "$target_dir" ]; then
        echo "Cloning $(basename "$repo_url") into '$target_dir'..."
        git clone "$repo_url" "$target_dir" || { echo "Failed to clone $(basename "$repo_url"). Exiting..."; exit 1; }
    else
        echo "$(basename "$repo_url") is already installed. Skipping."
    fi
}

# Function to setup the atlas directory
setup_atlas() {
    local dir="$1/atlas_dir"
    check_and_create_directory "$dir"
    if [ ! "$(ls -A $dir)" ]; then
        echo "Downloading and setting up atlas files..."
        wget https://zenodo.org/record/10103446/files/atlas.zip -P "$dir" || { echo "Failed to download atlas.zip. Exiting..."; exit 1; }
        wget https://zenodo.org/record/10103446/files/config.zip -P "$dir" || { echo "Failed to download config.zip. Exiting..."; exit 1; }
        unzip "$dir/atlas.zip" -d "$dir" || { echo "Failed to unzip atlas.zip. Exiting..."; exit 1; }
        unzip "$dir/config.zip" -d "$dir" || { echo "Failed to unzip config.zip. Exiting..."; exit 1; }
        rm "$dir"/*.zip
    else
        echo "Atlas folder already exists."
    fi
}

# Main script execution
main() {
    
    
    # Define the path to the configuration file
    DEFAULT_CONFIG_FILE="config.sh"

    # Check if an argument is provided
    if [ "$#" -eq 1 ]; then
        CONFIG_FILE="$1"
    else
        CONFIG_FILE="$DEFAULT_CONFIG_FILE"
    fi

    # Check if the config file exists
    if [ -f "$CONFIG_FILE" ]; then
        # Source the config file
        source "$CONFIG_FILE"
        echo "Using config file: $CONFIG_FILE"
    else
        echo "Error: Config file '$CONFIG_FILE' not found."
        exit 1
    fi

    local directory=$TOOLS_PATH
    check_and_create_directory "$directory"
    
    module load apptainer

    download_sif "$directory"
    
    clone_repo "https://github.com/scilus/tractoflow.git" "$directory/tractoflow"
    clone_repo "https://github.com/scilus/dmriqc_flow.git" "$directory/dmriqc_flow"
    clone_repo "https://github.com/scilus/rbx_flow.git" "$directory/rbx_flow"
    clone_repo "https://github.com/scilus/combine_flows.git" "$directory/combine_flows"
    clone_repo "https://github.com/scilus/tractometry_flow.git" "$directory/tractometry_flow"
    setup_atlas "$directory"
}

# Run the main function
main "$@"
