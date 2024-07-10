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
CURRENT_DATE=$(date +"%Y-%m-%d") # Current date in YYYY-MM-DD format
output_folder="${OUTPUT_DIR}/${CURRENT_DATE}_rbx" # This folder will be the input folder when running rbx.
combineflow_path="$TOOLS_PATH/combine_flows/tree_for_rbx_flow.sh"  # Path to the combine_flows script specific for rbx_flow


# Check if the variable rbx_inputs exists in the config file
if grep -q "^rbx_inputs=" "$CONFIG_FILE"; then
  # If the variable exists, update its value using sed
  sed -i "s/^rbx_inputs=.*/rbx_inputs=\"$output_folder\"/" "$CONFIG_FILE"
else
  # If the variable does not exist, append it to the config file
  echo "rbx_inputs=\"$output_folder\"" >> "$CONFIG_FILE"
fi

echo "Set rbx_inputs to $output_folder in $CONFIG_FILE, to be used in further steps. 
Modify it directly in the config file if you change the name of the results folder manually"


# Command to run the tree_for_rbx_flow.sh script with the specified arguments
cmd=" $combineflow_path \
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