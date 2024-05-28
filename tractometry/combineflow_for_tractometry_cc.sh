#!/bin/bash

tractoflow_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results"
rbx_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-28_rbx/results_rbx"
output_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-28_tractometry"


# Command to run the tree_for_tractometry.sh script with the specified arguments
cmd="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/combine_flows/tree_for_tractometry.sh \
    -t $tractoflow_results_folder \
    -r $rbx_results_folder \
    -o $output_folder"

# Display the command to be executed
echo "Executing command: $cmd"

# Execute the command
eval "$cmd"