#!/bin/bash


tractoflow_results_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results"
output_folder="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/for_rbx"

cmd="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/combine_flows/tree_for_rbx_flow.sh \
    -t $tractoflow_results_folder \
    -o $output_folder "

echo "$cmd"
eval "$cmd"