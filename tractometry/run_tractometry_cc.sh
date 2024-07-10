#!/bin/bash

# This script submits a job with sbatch with the ressources specified in the config.sh file. 
# To run this script use : bash tractometry/run_tractometry_cc.sh from the repository directory
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

my_singularity_img="${TOOLS_PATH}/containers/scilus_1.6.0.sif" # or .img
my_main_nf="${TOOLS_PATH}/tractometry_flow/main.nf"
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/tractometry_flow/main.nf'
my_input="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-28_tractometry"



cmd="nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img -resume \
    --skip_projection_endpoints_metrics \
    --use_provided_centroids"



TMP_SCRIPT=$(mktemp /tmp/slurm-tractometry_XXXXXX.sh)

# Write the SLURM script to the temporary file
cat <<EOT > $TMP_SCRIPT
#!/bin/bash
$_ressources

# Load necessary module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer

cd $my_input

# Create a readme.txt to keep track of options and date that this was ran
current_date=$(date)
echo -e "Tractometry pipeline\n" > readme.txt
echo -e "Date : $current_date\n" > readme.txt
echo -e "[Command-Line]\n" > readme.txt
echo $cmd > readme.txt

EOT

# uncomment to print the script in the terminal
cat $TMP_SCRIPT

# Submit the scipt as a slurm job
# sbatch $TMP_SCRIPT

# Uncomment to automatically remove the temporary script 
# rm /tmp/$TMP_SCRIPT