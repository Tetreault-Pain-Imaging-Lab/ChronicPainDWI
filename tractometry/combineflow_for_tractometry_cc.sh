#!/bin/bash


# Define the path to the configuration file
CONFIG_FILE="config.sh"

# Check if the configuration file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file not found."
  echo "Please ensure the current directory is ChronicPainDWI or a parent directory when running this script."
  exit 1
fi

# Source the configuration file
source "$CONFIG_FILE"

tractoflow_results_folder="$tractoflow_outputs/results"
rbx_results_folder="$rbx_inputs/results_rbx"

CURRENT_DATE=$(date +"%Y-%m-%d") # Current date in YYYY-MM-DD format
tractometry_inputs="${OUTPUT_DIR}/${CURRENT_DATE}_tractometry"
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