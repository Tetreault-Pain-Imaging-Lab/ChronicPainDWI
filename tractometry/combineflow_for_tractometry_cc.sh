#!/bin/bash

# To run this script cd into the repo's directory and use :
#  bash tractometry/combineflow_for_tractometry_cc.sh your_config.sh


# Define the path to the configuration file
DEFAULT_CONFIG_FILE="config_ex.sh"

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

tractoflow_results_folder="$tractoflow_outputs/results"
rbx_results_folder="$rbx_inputs/results_rbx"

tractometry_inputs="${OUTPUT_DIR}/tractometry"
combineflow_path="$TOOLS_PATH/combine_flows/tree_for_tractometry.sh"  # Path to the combine_flows script specific for rbx_flow

# Check if the variable tractometry_inputs exists in the config file
if grep -q "^tractometry_inputs=" "$CONFIG_FILE"; then
  # If the variable exists, update its value using sed
  sed -i "s/^tractometry_inputs=.*/tractometry_inputs=\"$tractometry_inputs\"/" "$CONFIG_FILE"
else
  # If the variable does not exist, append it to the config file
  echo "tractometry_inputs=\"$tractometry_inputs\"" >> "$CONFIG_FILE"
fi

echo "Set tractometry_inputs to $tractometry_inputs in $CONFIG_FILE, to be used in further steps. 
Modify it directly in the config file if you change the name of the results folder manually"


# Command to run the tree_for_tractometry.sh script with the specified arguments
cmd="$combineflow_path \
    -t $tractoflow_results_folder \
    -r $rbx_results_folder \
    -o $tractometry_inputs"

# Display the command to be executed
echo "Executing command: $cmd"

# Execute the command
eval "$cmd"