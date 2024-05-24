#!/bin/bash

# This would run RecobundleX with the following parameters:
#   - Population average atlas for RecobundlesX. DOI: 10.5281/zenodo.5165374

#SBATCH --job-name=rbx
#SBATCH --nodes=1              # --> Generally depends on your nb of subjects.
                               # See the comment for the cpus-per-task. One general rule could be
                               # that if you have more subjects than cores/cpus (ex, if you process 38
                               # subjects on 32 cpus-per-task), you could ask for one more node.
#SBATCH --cpus-per-task=32     # --> You can see here the choices. For beluga, you can choose 32, 40 or 64.
                               # https://docs.computecanada.ca/wiki/B%C3%A9luga/en#Node_Characteristics
#SBATCH --mem=0                # --> 0 means you take all the memory of the node. If you think you will need
                               # all the node, you can keep 0.
#SBATCH --time=30:00:00


#SBATCH --mail-user=ludo.a.levesque@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --output="/home/ludoal/scratch/ChronicPainDWI/outputs/rbx/slurm-%A.out"


module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

my_singularity_img='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/containers/scilus_1.6.0.sif' # or .img
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/rbx_flow/main.nf'
my_input='/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-24_rbx'
my_atlas_dir='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/atlas_dir'

cd $my_input

NXF_DEFAULT_DSL=1 nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img \
    -with-report report.html \
    --atlas_directory $my_atlas_dir \
    -resume 