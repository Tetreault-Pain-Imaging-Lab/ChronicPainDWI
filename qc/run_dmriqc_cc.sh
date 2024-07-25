#!/bin/bash

# This script runs the dmriqc_flow pipeline using the -profile option to run on different kind of outputs :
# 
# PROFILES (using -profile option (e.g. -profile tractoflow_qc_light,cbrain))
#     input_qc                            Create QC reports for your raw data (Can be a BIDS structure).

#     tractoflow_qc_light                 Create QC reports for your TractoFlow results:
#                                         Output important steps only.

#     tractoflow_qc_all                   Create QC reports for your TractoFlow results:
#                                         Output all steps.

#     rbx_qc                              Create QC reports for your rbx-flow results.


# To run this script cd into the repo's directory and use :
#  bash /home/ludoal/scratch/ChronicPainDWI/qc/run_dmriqc_cc.sh "profile" "your_config.sh"


# Define the path to the configuration file
DEFAULT_CONFIG_FILE="config.sh"

# Check if an config file argument is provided
if [ "$#" -eq 2 ]; then
    CONFIG_FILE="$2"
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


# Define paths for the Singularity image, Nextflow script, input data, and output directory
my_singularity_img="${TOOLS_PATH}/containers/scilus_1.6.0.sif" # or .img
my_main_nf="${TOOLS_PATH}/dmriqc_flow/main.nf"
my_profile="$1"
my_output_dir="${OUTPUT_DIR}/${my_profile}"


# Valid profiles
valid_profiles=("input_qc" "tractoflow_qc_light" "tractoflow_qc_all" "rbx_qc" )

# Function to check if the profile is valid
is_valid_profile() {
    for profile in "${valid_profiles[@]}"; do
        if [[ "$profile" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}

# Check if profile argument is provided
if [[ -z "$my_profile" ]]; then
    echo "Error: No profile specified."
    echo "Usage: $0 <profile>"
    echo "Available profiles: ${valid_profiles[*]}"
    exit 1
fi

# Check if profile is valid
if ! is_valid_profile "$my_profile"; then
    echo "Error: Invalid profile '$my_profile'."
    echo "Available profiles: ${valid_profiles[*]}"
    exit 1
fi

# Get input directory
case "$my_profile" in 
    "input_qc")
        my_input="$BIDS_DIR"
        ;;

    "tractoflow_qc_light" | "tractoflow_qc_all" )
        if test -z "${tractoflow_outputs+set}"; then
            my_input="${OUTPUT_DIR}/tractoflow/results"
        else
            my_input="$tractoflow_outputs"
        fi
        ;;

    "rbx_qc")
        if test -z "${rbx_inputs+set}"; then
            my_input="${OUTPUT_DIR}/rbx/results_rbx"
        else
            my_input="$rbx_inputs/results_rbx"
        fi
        ;;

esac

echo -e "Running profile : ${my_profile}\n on ${my_input} " 

# Create the command for the Nextflow pipeline using the defined parameters
cmd="nextflow run $my_main_nf \
    -profile $my_profile \
    -with-singularity $my_singularity_img \
    --input $my_input \
    --output_dir $my_output_dir \
    -resume"

    
TMP_SCRIPT=$(mktemp /tmp/slurm-qc_XXXXXX.sh)

# Write the SLURM script to the temporary file
cat <<EOT > $TMP_SCRIPT
#!/bin/bash
$QC_ressources

# Load necessary module
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer

echo -e "Running profile : ${my_profile}\n on ${my_input} " 

if [ ! -d $my_output_dir ]; then
    mkdir -p $my_output_dir
fi
cd $my_output_dir

$cmd

EOT

# uncomment to print the script in the terminal
# cat $TMP_SCRIPT

# Submit the scipt as a slurm job
sbatch $TMP_SCRIPT