#!/bin/bash


#SBATCH --job-name=run_tractometry
#SBATCH --time=1:00:00
#SBATCH --nodes=1              # --> Generally depends on your nb of subjects.
                               # See the comment for the cpus-per-task. One general rule could be
                               # that if you have more subjects than cores/cpus (ex, if you process 38
                               # subjects on 32 cpus-per-task), you could ask for one more node.
#SBATCH --cpus-per-task=32     # --> You can see here the choices. For beluga, you can choose 32, 40 or 64.
                               # https://docs.computecanada.ca/wiki/B%C3%A9luga/en#Node_Characteristics
#SBATCH --mem=0                # --> 0 means you take all the memory of the node. If you think you will need
                               # all the node, you can keep 0.


#SBATCH --mail-user=ludo.a.levesque@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --output="/home/ludoal/scratch/ChronicPainDWI/outputs/tractometry/slurm-%A.out"


module load StdEnv/2020 java/14.0.2 nextflow/21.10.3 apptainer/1.1.8

my_singularity_img='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/containers/scilus_1.6.0.sif' # or .img
my_main_nf='/home/ludoal/projects/def-pascalt-ab/ludoal/dev_scil/tractometry_flow/main.nf'
my_input="/home/ludoal/scratch/tpil_data/BIDS_longitudinal/2024-05-28_tractometry"

cd "$my_input" 

cmd="nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img -resume \
    --skip_projection_endpoints_metrics \
    --use_provided_centroids"

eval $cmd

current_date=$(date)
echo -e "Tractometry pipeline\n" > readme.txt
echo -e "Date : $current_date\n" > readme.txt
echo -e "[Command-Line]\n" > readme.txt
echo $cmd > readme.txt