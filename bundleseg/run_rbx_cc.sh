#!/bin/bash

# This would run RecobundleX with the following parameters:
#   - Population average atlas for RecobundlesX. DOI:  10.5281/zenodo.10103446

# This script submits a job with sbatch with the ressources specified in the config.sh file. 
# To run this script use : bash bundleseg/run_rbx_cc.sh your_config.sh
#  


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
my_main_nf="${TOOLS_PATH}/rbx_flow/main.nf"
my_input=$rbx_inputs
my_atlas_dir="${TOOLS_PATH}/atlas_dir"

cmd="NXF_DEFAULT_DSL=1 nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img \
    -with-report report.html \
    --atlas_directory $my_atlas_dir \
    -resume"



TMP_SCRIPT=$(mktemp /tmp/slurm-rbx_XXXXXX.sh)

# Write the SLURM script to the temporary file
cat <<EOT > $TMP_SCRIPT
#!/bin/bash
$rbx_ressources


# Load necessary module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer

cd $my_input

# Create a readme.txt to keep track of options and date that this was ran
current_date=$(date)
echo -e "Rbx pipeline\n" > readme.txt
echo -e "Date : $current_date\n" > readme.txt
echo -e "[Command-Line]\n" > readme.txt
echo $cmd > readme.txt

$cmd


EOT

# uncomment to print the script in the terminal
# cat $TMP_SCRIPT

# Submit the scipt as a slurm job
sbatch $TMP_SCRIPT

# Uncomment to automatically remove the temporary script 
# rm /tmp/$TMP_SCRIPT