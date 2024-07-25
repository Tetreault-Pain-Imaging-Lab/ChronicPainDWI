#!/bin/bash


# This files contains variables for you to set manually to be used in the scripts of this repository

# REPOS_DIR is the where you installed/cloned the ChronicPainDWI on your machine ChronicPainDWI
REPOS_DIR="/home/ludoal/scratch/ChronicPainDWI"

# The tools_path is going to contain all tools like the sclilus lab container and their nextflow tools.
# We recommend you choose a path on your /user/projects directory to prevent it from being purged.
# It will be first used in the script /utils/install_tools_cc.sh, then as a reference to find tools
TOOLS_PATH="/home/ludoal/projects/def-pascalt-ab/ludoal/dev_tpil/tools"

 
#  BIDS_dir is the path where you have your raw BIDS formatted dataset. 
#  It should contain the subject folders and the following files :
#       -participants.tsv :
#       -participants.json : necessary for BIDS format (see BIDS documentation for what it should contain)
#       -dataset_description.json : necessary for BIDS format
BIDS_DIR="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/data_raw_for_test"

# The results will be stored in folders named after the pipeline that produced them under the OUTPUT_DIR
OUTPUT_DIR="/home/ludoal/scratch/tpil_data/BIDS_longitudinal"


###############################         Ressource alloacation         ##########################################
#
# SLURM Parameters info :
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
#   --output: Path to the output log file for the SLURM job. %A is the job ID.
#
# To monitor tasks use portals like https://portail.narval.calculquebec.ca/ (for narval)

#  Set the following variables to adjust ressources to your need. You will have to set them for every sbatch script (run_tractoflow_cc.sh, run_rbx_cc.sh and run_tractometry_cc.sh)

# General SBATCH directives 
MAIL="ludo.a.levesque@gmail.com"  # optionnal, remove the `#SBATCH --mail` lines in the ressources variables if you don't want this option
SLURM_OUT="/home/ludoal/scratch/ChronicPainDWI/outputs/tpil" 

# tractoflow ressources allocation (uesd in for the script /tractoflow/run_tractoflow_cc.sh)
tractoflow_ressources="#SBATCH --job-name=tractoflow
#SBATCH --time=20:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=60G
#SBATCH --output=\"$SLURM_OUT/tractoflow/slurm-tractoflow_%A.out\"   
#SBATCH --mail-user=$MAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE"


# rbx ressources (used in the script ChronicPainDWI/bundleseg/run_rbx_cc.sh)
rbx_ressources="#SBATCH --job-name=run_rbx
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G
#SBATCH --output=\"$SLURM_OUT/rbx/slurm-rbx_%A.out\"   
#SBATCH --mail-user=$MAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE"

# Tractometry ressource allocation 
tractometry_ressources="#SBATCH --job-name=tractometry_50
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G
#SBATCH --output=\"$SLURM_OUT/tractometry/slurm-%A.out\"
#SBATCH --mail-user=$MAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL"


# Quality Control script ressources
QC_ressources="#SBATCH --nodes=1              
#SBATCH --cpus-per-task=10    
#SBATCH --mem=20G             
#SBATCH --time=2:00:00         
#SBATCH --output=$SLURM_OUT/qc/slurm-%A_rbx.out"


# Some variables might be added here by some scripts to speed up processing:
tractoflow_outputs="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-07-10_tractoflow"
rbx_inputs="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-07-11_rbx"
tractometry_inputs="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-07-16_tractometry"
