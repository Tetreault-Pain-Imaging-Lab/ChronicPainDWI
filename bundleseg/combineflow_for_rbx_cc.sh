#!/bin/bash

# Exemple usage :
# bash /home/ludoal/scratch/ChronicPainDWI/bundleseg/combineflow_for_rbx_cc.sh /home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-24_tractoflow /home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-24_rbx

# display usage information
usage() {
    echo "Usage: $0 <tractoflow_results_folder> <output_folder>"
    echo
    echo "Arguments:"
    echo "  tractoflow_results_folder   The path to the TractoFlow results folder."
    echo "  output_folder               The path where to store the outputs."
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
# output_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-24_rbx"


# Command to run the tree_for_rbx_flow.sh script with the specified arguments
cmd="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/combine_flows/tree_for_rbx_flow.sh \
    -t $tractoflow_results_folder \
    -o $output_folder"

# Display the command to be executed
echo "Executing command: $cmd"

# Execute the command
eval "$cmd"

if [ -d "${output_folder}/work" ]; then
    rm -r "${output_folder}/work"
fi 
if [ -d "${output_folder}/report.html" ]; then
    rm -r "${output_folder}/report.html"
fi 