#!/bin/bash

# # display usage information
# usage() {
#     echo "Usage: $0 <tractoflow_results_folder> <output_folder>"
#     echo
#     echo "Arguments:"
#     echo "  tractoflow_results_folder   The path to the TractoFlow results folder."
#     echo "  rbx_results_folder          The path to the TractoFlow results folder."
#     echo "  output_folder               The path where to store the outputs."
#     exit 1
# }

# # Check if the correct number of arguments is provided
# if [ "$#" -ne 3 ]; then
#     echo "Invalid arguments."
#     usage
# fi

# # Assign arguments to variables
# tractoflow_results_folder="$1"
# rbx_results_folder="$2"
# output_folder="$3"

# for testing
tractoflow_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results"
rbx_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-24_rbx/results_rbx"
output_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-27_tractometry"


# Command to run the tree_for_tractometry.sh script with the specified arguments
cmd="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/combine_flows/tree_for_tractometry.sh \
    -t $tractoflow_results_folder \
    -r $rbx_results_folder \
    -o $output_folder"

# Display the command to be executed
echo "Executing command: $cmd"

# Execute the command
eval "$cmd"