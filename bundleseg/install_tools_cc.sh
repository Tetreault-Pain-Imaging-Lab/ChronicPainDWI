#!/bin/bash

# Help message function
display_help() {
    echo "Usage: $0 [directory]"
    echo "Installs TractoFlow in the specified directory."
    echo "Arguments:"
    echo "  directory   The directory where TractoFlow will be installed."
}

# Check for the --help option
if [[ "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check for the number of command-line arguments
if [[ $# -eq 0 ]]; then
    echo "Error: Not enough arguments. Provide the directory where you want to install TractoFlow."
    exit 1
elif [[ $# -gt 1 ]]; then
    echo "Error: Too many arguments."
    exit 1
fi

# Initialize a variable 'directory' with the value of the argument
directory="$1"
if [ -d "$directory" ]; then
    # Directory exists
    echo "Directory exists."
else
    # Directory does not exist
    echo "Directory does not exists, creating it ..."
    mkdir "$directory"
fi

# Load the required module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

# Clone the necessary repository for preprocessing
tractoflow_path="${directory}/tractoflow"
dmriqc_path="${directory}/dmriqc_flow"

if [ -d "$tractoflow_path" ]; then
    echo "tractoflow is already installed."
else
    git clone https://github.com/scilus/tractoflow.git "${directory}/tractoflow" || exit 1
fi

if [ -d "$dmriqc_path" ]; then
    echo "dmriqc_flow is already installed."
else
    git clone https://github.com/scilus/dmriqc_flow.git "${directory}/dmriqc_flow" || exit 1
fi



# Build the .sif file in a directory called containers
if [ -d "${directory}/containers" ]; then
    # Directory exists
    wget https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif || exit 1
else
    # Directory does not exist
    mkdir "$directory"
fi
mkdir containers
wget https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif || exit 1

