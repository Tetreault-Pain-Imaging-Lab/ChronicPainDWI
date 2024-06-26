#!/bin/bash

# This would run dmriqc_flow with the following parameters:
#   -profile tractoflow_qc_all : Create QC reports for your TractoFlow results and outputs all file


#SBATCH --nodes=1              # --> Generally depends on your nb of subjects.
                               # See the comment for the cpus-per-task. One general rule could be
                               # that if you have more subjects than cores/cpus (ex, if you process 38
                               # subjects on 32 cpus-per-task), you could ask for one more node.
#SBATCH --cpus-per-task=10     # --> You can see here the choices. For beluga, you can choose 32, 40 or 64.
                               # https://docs.computecanada.ca/wiki/B%C3%A9luga/en
                               #Node_Characteristics
#SBATCH --mem=0                # --> 0 means you take all the memory of the node. If you think you will need
                               # all the node, you can keep 0.
#SBATCH --time=10:00:00

module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/dmriqc_flow/main.nf'
my_input='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/tractoflow_results'  # depends on the profile option ...
my_output_dir='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/qc_tractoflow'

if [ ! -d $my_output_dir ]; then
    mkdir $my_output_dir 
fi
cd $my_output_dir

NXF_VER=nextflow/21.10.3 nextflow run $my_main_nf \
    -profile tractoflow_qc_all \
    --input $my_input \
    -resume
