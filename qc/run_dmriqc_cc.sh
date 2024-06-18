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

#     disconets_qc                       Create QC reports for your disconets_flow results.

#     cbrain                              When this profile is used, Nextflow will copy all the output files in publishDir and not use symlinks.
#                                         cbrain profile should be used as a second profile (e.g -profile input_qc,cbrain).

# It uses SLURM for job scheduling and Nextflow for workflow execution.
# Ensure you adjust SLURM parameters based on your requirements and cluster specifications 
# and change the path variables for your dataset
# 
# SLURM Parameters:
#   --nodes: Number of nodes to allocate. Generally depends on the number of subjects and available cores per task.
#            If you have more subjects than cores (e.g., 38 subjects and 32 cpus-per-task), consider requesting an additional node.
#   --cpus-per-task: Number of CPUs to allocate per task. Choose based on your cluster's available configurations. 
#                    For example, Beluga allows 32, 40, or 64 CPUs per task.
#                    More information: https://docs.computecanada.ca/wiki/B%C3%A9luga/en#Node_Characteristics
#   --mem: Memory allocation per node. Setting this to 0 allocates all available memory on the node.
#          Adjust based on expected memory usage.
#   --time: Maximum job runtime. Adjust based on your pipeline's expected duration.
#   --mail-user: Email address for job notifications.
#   --mail-type: Conditions under which to send job status emails (BEGIN, END, FAIL, REQUEUE, ALL).
#   --output: Path to the output log file for the SLURM job.

#SBATCH --nodes=1              
#SBATCH --cpus-per-task=10     
#SBATCH --mem=20G             
#SBATCH --time=1:00:00         
#SBATCH --output="/home/ludoal/scratch/ChronicPainDWI/outputs/qc/slurm-%A.out" 

# Example usage: sbatch /home/ludoal/scratch/ChronicPainDWI/qc/run_dmriqc_cc.sh tractoflow_qc_all


# Load necessary modules
module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

# Define paths for the Singularity image, Nextflow script, input data, and output directory
my_singularity_img='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_tpil/tools/containers/scilus_1.6.0.sif'   
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_tpil/tools/dmriqc_flow/main.nf'             # dmriqc_flow script path
my_input='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-27_tractoflow/results'               # This needs to match profile
my_output_dir='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/qc_tractoflow'
my_profile="$1"

# Valid profiles
valid_profiles=("input_qc" "tractoflow_qc_light" "tractoflow_qc_all" "rbx_qc" "disconets_qc" "cbrain")

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

# Run the Nextflow pipeline using the defined parameters
nextflow run $my_main_nf \
    -profile $my_profile \
    -with-singularity $my_singularity_img \
    --input $my_input \
    --output_dir $my_output_dir \
    -resume