#!/bin/bash

# Help message function
display_help() {
    echo "Usage: $0 [directory]"
    echo "Installs the scilus lab's tools usefull for DMRI in the specified directory."
    echo "Arguments:"
    echo "  directory  The directory where the tools will be installed."
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

# Build the .sif file in a directory called containers
if [ ! -d "${directory}/containers" ]; then
    mkdir "${directory}/containers" || || { echo "Failed to create containers directory. Exiting..."; exit 1; }
fi

if [ ! -f "${directory}/containers/scilus_1.6.0.sif " ]; then
    wget https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif || exit 1
    mv scilus_1.6.0.sif "${directory}/containers"
fi

# Clone the necessary repository in the specified directory
tractoflow_path="${directory}/tractoflow"
dmriqc_path="${directory}/dmriqc_flow"
rbx_path="${directory}/rbx_flow"
combineflow_path="${directory}/combine_flows"

if [ -d "$tractoflow_path" ]; then
    echo "tractoflow is already installed."
else
    git clone https://github.com/scilus/tractoflow.git "$tractoflow_path" || exit 1
fi

if [ -d "$dmriqc_path" ]; then
    echo "dmriqc_flow is already installed."
else
    git clone https://github.com/scilus/dmriqc_flow.git "$dmriqc_path" || exit 1
fi

if [ -d "$rbx_path" ]; then
    echo "rbx_flow is already installed."
else
    git clone https://github.com/scilus/rbx_flow.git "$rbx_path" || exit 1
fi

if [ -d "$combineflow_path" ]; then
    echo "combine_flow is already installed."
else
    git clone https://github.com/scilus/combine_flows.git "$combineflow_path" || exit 1
fi
