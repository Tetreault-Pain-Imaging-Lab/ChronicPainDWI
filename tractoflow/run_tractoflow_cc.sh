#!/bin/bash

# This would run Tractoflow with the following parameters:
#   - bids: clinical data from TPIL lab (27 CLBP and 25 control subjects), if not in BIDS format use flag --input
#   - with-singularity: container image scilus v1.4.0 (runs: dmriqc_flow, tractoflow, recobundleX, tractometry)
#   - with-report: outputs a processing report when pipeline is finished running
#   - Dti_shells 0 and 1000 (usually <1200), Fodf_shells 0 1000 and 2000 (usually >700, multishell CSD-ms).
#   - profile: bundling, bundling profile will set the seeding strategy to WM as opposed to interface seeding that is usually used for connectomics
#   --local_batch_size_gpu 0 : This prevents it from crahsing when not using gpus

# This script submits a job with sbatch with the ressources specified in the my_variables.sh file. 
# To run this script use : bash tractoflow/run_tractoflow_cc.sh from the repository directory
#  


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


# Path where you installed the scilus container (see utils/instal_tools)
my_singularity_img="${TOOLS_PATH}/containers/scilus_1.6.0.sif" # or .img

# Path to tractoflow's main.nf script where you installed tractoflow (see utils/instal_tools)
my_main_nf="${TOOLS_PATH}/tractoflow/main.nf"

# Path to the BIDS formated data (containing all subjects and all sesions)
my_input=$BIDS_DIR

# Path of the tractoflow output. Adding a date helps to keep track of versions, but not necessary
CURRENT_DATE=$(date +"%Y-%m-%d") # Current date in YYYY-MM-DD format
my_output_dir="${OUTPUT_DIR}/${CURRENT_DATE}_tractoflow"

# Check if the variable tractoflow_results_folder exists in the config file
if grep -q "^tractoflow_outputs=" "$CONFIG_FILE"; then
  # If the variable exists, update its value using sed
  sed -i "s|^tractoflow_outputs=.*|tractoflow_outputs=\"$my_output_dir\"|" "$CONFIG_FILE"
else
  # If the variable does not exist, append it to the config file
  echo "tractoflow_outputs=\"$my_output_dir\"" >> "$CONFIG_FILE"
fi

echo "Set tractoflow_outputs to $my_output_dir in $CONFIG_FILE, to be used in further steps. 
Modify it directly in the config file if you change the name of the results folder manually"


# Nextflow command that runs tractoflow with the specified paths and options
nf_command="nextflow run $my_main_nf --bids $my_input -with-singularity $my_singularity_img -resume -with-report "${my_output_dir}/report.html" --dti_shells \"0 1000\" --fodf_shells \"0 1000 2000\" -profile bundling --run_gibbs_correction true --local_batch_size_gpu 0"


TMP_SCRIPT=$(mktemp /tmp/slurm-tractoflow_XXXXXX.sh)

# Write the SLURM script to the temporary file
cat <<EOT > $TMP_SCRIPT
#!/bin/bash
$tractoflow_ressources

# Load necessary module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer

# Make sure the output directory exists
if [ ! -d $my_output_dir ]; then
    mkdir -p $my_output_dir
fi

cd $my_output_dir

# show the nextflow command line, then run it
echo "$nf_command"

$nf_command

EOT

# uncomment to print the script in the terminal
# cat $TMP_SCRIPT

# Submit the scipt as a slurm job
sbatch $TMP_SCRIPT

# Uncomment to automatically remove the temporary script 
# rm /tmp/$TMP_SCRIPT

 