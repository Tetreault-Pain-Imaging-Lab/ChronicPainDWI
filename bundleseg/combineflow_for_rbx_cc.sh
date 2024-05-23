#!/bin/bash

# display usage information
usage() {
    echo "Usage: $0 <tractoflow_results_folder> <output_folder>"
    echo
    echo "Arguments:"
    echo "  tractoflow_results_folder   The path to the TractoFlow results folder."
    echo "  output_folder              The path to the output folder."
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Invalid arguments."
    usage
fi

# Assign arguments to variables
tractoflow_results_folder="$1"
output_folder="$2"

# tractoflow_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results"
# output_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/for_rbx"


# Command to run the tree_for_rbx_flow.sh script with the specified arguments
cmd="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/combine_flows/tree_for_rbx_flow.sh \
    -t $tractoflow_results_folder \
    -o $output_folder"

# Display the command to be executed
echo "Executing command: $cmd"

# Execute the command
eval "$cmd"

# ln -s  /home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results/sub-002_ses-v1/*Tracking/*.trk /home/ludoal/scratch/tpil_data/BIDS_longitudinal/for_rbx/sub-002_ses-v1
# ln -s  /home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results/sub-002_ses-v1/DTI_Metrics/*fa.nii.gz /home/ludoal/scratch/tpil_data/BIDS_longitudinal/for_rbx/sub-002_ses-v1/fa.nii.gz