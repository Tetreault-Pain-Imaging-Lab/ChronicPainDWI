#!/bin/bash

# STILL IN TESTING 

# This would run Tractoflow with the following parameters:
#   - bids: clinical data from TPIL lab (27 CLBP and 25 control subjects), if not in BIDS format use flag --input
#   - with-singularity: container image scilus v1.4.0 (runs: dmriqc_flow, tractoflow, recobundleX, tractometry)
#   - with-report: outputs a processing report when pipeline is finished running
#   - Dti_shells 0 and 1000 (usually <1200), Fodf_shells 0 1000 and 2000 (usually >700, multishell CSD-ms).
#   - profile: bundling, bundling profile will set the seeding strategy to WM as opposed to interface seeding that is usually used for connectomics

#SBATCH --job-name=gpu_tractoflow
#SBATCH --nodes=1              # --> Generally depends on your nb of subjects.
                               # See the comment for the cpus-per-task. One general rule could be
                               # that if you have more subjects than cores/cpus (ex, if you process 38
                               # subjects on 32 cpus-per-task), you could ask for one more node.
#SBATCH --cpus-per-task=32     # --> You can see here the choices. For beluga, you can choose 32, 40 or 64.
                               # https://docs.computecanada.ca/wiki/B%C3%A9luga/en#Node_Characteristics
#SBATCH --mem=0                # --> 0 means you take all the memory of the node. If you think you will need
                               # all the node, you can keep 0

#SBATCH --gpus-per-node=4
#SBATCH --time=30:00:00

#SBATCH --mail-user=ludo.a.levesque@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --output="/home/ludoal/scratch/ChronicPainDWI/outputs/slurm-%A.out"


module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8


my_singularity_img='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/containers/scilus_1.6.0.sif' # or .img
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/tractoflow/main.nf'
my_input='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/data_raw_for_test'
my_bidsignore='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/.bidsignore_tractoflow' 
my_output_dir='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results'

nextflow run $my_main_nf --bids $my_input \
    -with-singularity $my_singularity_img -resume -with-report "${my_output_dir}/report.html" \
    --dti_shells "0 1000" --fodf_shells "0 1000 2000" -profile bundling --run_gibbs_correction true \
    --bidsignore $my_bidsignore \
    --profile use_gpu \
    --output_dir $my_output_dir \
    --local_batch_size_gpu 10000