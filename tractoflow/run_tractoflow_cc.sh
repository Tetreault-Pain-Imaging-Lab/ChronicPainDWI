#!/bin/bash

# This would run Tractoflow with the following parameters:
#   - bids: clinical data from TPIL lab (27 CLBP and 25 control subjects), if not in BIDS format use flag --input
#   - with-singularity: container image scilus v1.4.0 (runs: dmriqc_flow, tractoflow, recobundleX, tractometry)
#   - with-report: outputs a processing report when pipeline is finished running
#   - Dti_shells 0 and 1000 (usually <1200), Fodf_shells 0 1000 and 2000 (usually >700, multishell CSD-ms).
#   - profile: bundling, bundling profile will set the seeding strategy to WM as opposed to interface seeding that is usually used for connectomics
#   --local_batch_size_gpu 0 : This prevents it from crahsing when not using gpus

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
#   --output: Path to the output log file for the SLURM job. %A is the job ID.
#
# To monitor tasks use portals like https://portail.narval.calculquebec.ca/ (for narval)

#SBATCH --job-name=run_tractoflow
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=10G
#SBATCH --output="/home/ludoal/scratch/ChronicPainDWI/outputs/ulaval/tractoflow/slurm-%A.out"  
#SBATCH --mail-user=ludo.a.levesque@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL


module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

# Path where you installed the scilus container (see utils/instal_tools)
my_singularity_img='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_tpil/tools/containers/scilus_1.6.0.sif' # or .img
# Path to tractoflow's main.nf script where you installed tractoflow (see utils/instal_tools)
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_tpil/tools/tractoflow/main.nf'
# Path to the BIDS formated data (containing all subjects and all sesions)
my_input='/home/ludoal/scratch/ulaval_test/data'
# Path of the tractoflow output. Adding a date helps to keep track of versions, but not necessary
my_output_dir='/home/ludoal/scratch/ulaval_test/results/tractoflow/'


if [ ! -d $my_output_dir ]; then
    mkdir -p $my_output_dir
fi
cd $my_output_dir

nextflow run $my_main_nf --bids $my_input \
    -with-singularity $my_singularity_img -resume -with-report "${my_output_dir}/report.html" \
    --dti_shells "0 1000" --fodf_shells "0 1000 2000" -profile bundling --run_gibbs_correction true \
    --local_batch_size_gpu 0
