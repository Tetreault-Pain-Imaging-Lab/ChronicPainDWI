#!/bin/bash

tractoflow_results_folder='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-27_tractoflow/results'
output_folder='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-28_rbx' # This folder will be the input folder when running rbx.


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