#!/bin/bash

# This script submits a job with sbatch with the ressources specified in the config.sh file. 
# To run this script cd into the repo's directory and use : bash tractometry/run_tractometry_cc.sh your_config.sh
# ex :  bash tractometry/run_tractometry_cc.sh config_test.sh

# Define the path to the configuration file
DEFAULT_CONFIG_FILE="config.sh"

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


my_singularity_img="${TOOLS_PATH}/containers/scilus_1.6.0.sif" # or .img
my_main_nf="${TOOLS_PATH}/tractometry_flow/main.nf"
my_input=$tractometry_inputs
current_date=$(date +"%Y-%m-%d")

if [ ! -n "${nb_points}" ]; then
    nb_points='20' # 20 is the default nb of points that tractometry segments the tracks
fi

cmd="nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img -resume \
    --skip_projection_endpoints_metrics \
    --use_provided_centroids \
    --skip_projection_endpoints_metrics \
    --nb_points $nb_points"



TMP_SCRIPT=$(mktemp /tmp/slurm-tractometry_XXXXXX.sh)

# Write the SLURM script to the temporary file
cat <<EOT > $TMP_SCRIPT
#!/bin/bash
$tractometry_ressources

# Load necessary module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer

cd $my_input

# Create a readme.txt to keep track of options and date that this was ran
echo -e "Tractometry pipeline\n" > readme.txt
echo -e "Date : $current_date\n" > readme.txt
echo -e "[Command-Line]\n" > readme.txt
echo "$cmd" > readme.txt


$cmd

EOT

# uncomment to print the script in the terminal
# cat $TMP_SCRIPT

# Submit the scipt as a slurm job
sbatch $TMP_SCRIPT

# Uncomment to automatically remove the temporary script
# sleep 10s 
# rm $TMP_SCRIPT